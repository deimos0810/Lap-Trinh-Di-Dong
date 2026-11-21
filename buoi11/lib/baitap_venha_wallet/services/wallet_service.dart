import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class WalletService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  String get currentUid => _auth.currentUser?.uid ?? "demo_wallet_user";

  // 1. Quen mat khau
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // 2. Khoi tao hoac lay thong tin nguoi dung & nap giao dich mau neu chua co
  Future<void> initUserDataIfNew() async {
    try {
      final userDoc = _firestore.collection('wallet_users').doc(currentUid);
      final snapshot = await userDoc.get();
      if (!snapshot.exists) {
        await userDoc.set({
          'uid': currentUid,
          'email': currentUser?.email ?? 'user@zhippay.com',
          'displayName': currentUser?.displayName ?? 'Người dùng ZhipPay',
          'avatarUrl': currentUser?.photoURL ?? '',
          'balance': 2108.22, // So du mau nhu trong slide
          'points': 6350,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Kiem tra va tu dong nap 3 giao dich mau chuan theo slide mockup neu chua co
      final transCheck = await _firestore
          .collection('wallet_transactions')
          .where('userId', isEqualTo: currentUid)
          .limit(1)
          .get();

      if (transCheck.docs.isEmpty) {
        final sampleTrans = [
          {
            'userId': currentUid,
            'type': 'withdraw',
            'title': 'Cardless withdraw',
            'amount': -232.80,
            'targetEmail': '',
            'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 3))),
          },
          {
            'userId': currentUid,
            'type': 'transfer_out',
            'title': 'Bank transfer to Greg Stan',
            'amount': -170.09,
            'targetEmail': 'greg.stan@gmail.com',
            'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
          },
          {
            'userId': currentUid,
            'type': 'topup',
            'title': 'Deposit',
            'amount': 32.65,
            'targetEmail': '',
            'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2))),
          },
        ];
        for (var st in sampleTrans) {
          final docRef = _firestore.collection('wallet_transactions').doc();
          await docRef.set({
            'id': docRef.id,
            ...st,
          });
        }
      }
    } catch (e) {
      debugPrint("Error in initUserDataIfNew: $e");
    }
  }

  // 3. Stream thong tin nguoi dung
  Stream<DocumentSnapshot> streamUserProfile() {
    return _firestore.collection('wallet_users').doc(currentUid).snapshots();
  }

  // 4. Cap nhat Profile va doi Avatar (Ho tro ca Firebase Storage & Base64 Fallback)
  Future<void> updateProfile({String? displayName, File? avatarFile}) async {
    String? newAvatarUrl;

    if (avatarFile != null) {
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('avatars/${currentUid}_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(avatarFile);
        newAvatarUrl = await ref.getDownloadURL();
      } catch (_) {
        // Fallback Base64 neu Storage chua gan the Blaze
        final bytes = await avatarFile.readAsBytes();
        newAvatarUrl = "base64:${base64Encode(bytes)}";
      }
      try {
        await currentUser?.updatePhotoURL(newAvatarUrl);
      } catch (_) {}
    }

    if (displayName != null && displayName.isNotEmpty) {
      try {
        await currentUser?.updateDisplayName(displayName);
      } catch (_) {}
    }

    final updateData = <String, dynamic>{};
    if (displayName != null) updateData['displayName'] = displayName;
    if (newAvatarUrl != null) updateData['avatarUrl'] = newAvatarUrl;

    if (updateData.isNotEmpty) {
      await _firestore.collection('wallet_users').doc(currentUid).set(updateData, SetOptions(merge: true));
    }
  }

  // 5. Nap tien (Top Up)
  Future<void> topUp(double amount) async {
    if (amount <= 0) return;
    final userRef = _firestore.collection('wallet_users').doc(currentUid);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      final currentBal = ((snapshot.data()?['balance'] ?? 2108.22) as num).toDouble();

      transaction.set(userRef, {'balance': currentBal + amount}, SetOptions(merge: true));

      final transRef = _firestore.collection('wallet_transactions').doc();
      transaction.set(transRef, {
        'id': transRef.id,
        'userId': currentUid,
        'type': 'topup',
        'title': 'Deposit / Top Up',
        'amount': amount,
        'targetEmail': '',
        'timestamp': Timestamp.now(),
      });
    });
  }

  // 6. Rut tien (Withdraw)
  Future<void> withdraw(double amount) async {
    if (amount <= 0) return;
    final userRef = _firestore.collection('wallet_users').doc(currentUid);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      final currentBal = ((snapshot.data()?['balance'] ?? 2108.22) as num).toDouble();

      if (currentBal < amount) {
        throw Exception("Số dư trong ví không đủ để rút tiền!");
      }

      transaction.set(userRef, {'balance': currentBal - amount}, SetOptions(merge: true));

      final transRef = _firestore.collection('wallet_transactions').doc();
      transaction.set(transRef, {
        'id': transRef.id,
        'userId': currentUid,
        'type': 'withdraw',
        'title': 'Cardless withdraw',
        'amount': -amount,
        'targetEmail': '',
        'timestamp': Timestamp.now(),
      });
    });
  }

  // 7. Chuyen tien an toan (Transfer qua Transaction)
  Future<void> transferMoney({
    required String receiverEmail,
    required double amount,
    String? note,
  }) async {
    if (amount <= 0) return;
    final senderRef = _firestore.collection('wallet_users').doc(currentUid);

    // Tim nguoi nhan
    final receiverQuery = await _firestore
        .collection('wallet_users')
        .where('email', isEqualTo: receiverEmail.trim())
        .limit(1)
        .get();

    String receiverId = "recipient_account";
    if (receiverQuery.docs.isNotEmpty) {
      final rDoc = receiverQuery.docs.first;
      if (rDoc.id == currentUid) {
        throw Exception("Không thể tự chuyển tiền cho chính mình!");
      }
      receiverId = rDoc.id;
    }

    final receiverRef = _firestore.collection('wallet_users').doc(receiverId);

    await _firestore.runTransaction((transaction) async {
      final senderSnapshot = await transaction.get(senderRef);
      final senderBal = ((senderSnapshot.data()?['balance'] ?? 2108.22) as num).toDouble();

      if (senderBal < amount) {
        throw Exception("Số dư của bạn không đủ (\$${senderBal.toStringAsFixed(2)})");
      }

      final receiverSnapshot = await transaction.get(receiverRef);
      final receiverBal = ((receiverSnapshot.data()?['balance'] ?? 0.0) as num).toDouble();

      transaction.set(senderRef, {'balance': senderBal - amount}, SetOptions(merge: true));
      transaction.set(receiverRef, {'balance': receiverBal + amount}, SetOptions(merge: true));

      // Luu giao dich chuyen di
      final senderTrans = _firestore.collection('wallet_transactions').doc();
      transaction.set(senderTrans, {
        'id': senderTrans.id,
        'userId': currentUid,
        'type': 'transfer_out',
        'title': note ?? 'Bank transfer',
        'amount': -amount,
        'targetEmail': receiverEmail,
        'timestamp': Timestamp.now(),
      });

      // Luu giao dich nhan tien
      final receiverTrans = _firestore.collection('wallet_transactions').doc();
      transaction.set(receiverTrans, {
        'id': receiverTrans.id,
        'userId': receiverId,
        'type': 'transfer_in',
        'title': 'Nhận tiền chuyển khoản',
        'amount': amount,
        'targetEmail': currentUser?.email ?? 'Người gửi',
        'timestamp': Timestamp.now(),
      });
    });
  }

  // 8. Stream danh sach giao dich gan day (Khong can Firestore Composite Index)
  Stream<QuerySnapshot> streamRecentTransactions({int limit = 10}) {
    return _firestore
        .collection('wallet_transactions')
        .where('userId', isEqualTo: currentUid)
        .snapshots();
  }

  // 9. Lay giao dich theo khoang ngay (Loc va sap xep trong bo nho, khong can Index tren Console)
  Future<List<Map<String, dynamic>>> getTransactionsByRange(int daysAgo) async {
    try {
      final query = await _firestore
          .collection('wallet_transactions')
          .where('userId', isEqualTo: currentUid)
          .get();

      final threshold = DateTime.now().subtract(Duration(days: daysAgo));
      final list = <Map<String, dynamic>>[];

      for (var doc in query.docs) {
        final data = doc.data();
        final ts = data['timestamp'] as Timestamp?;
        final date = ts?.toDate() ?? DateTime.now();
        if (date.isAfter(threshold)) {
          list.add(data);
        }
      }

      list.sort((a, b) {
        final tA = (a['timestamp'] as Timestamp?)?.toDate() ?? DateTime(2020);
        final tB = (b['timestamp'] as Timestamp?)?.toDate() ?? DateTime(2020);
        return tB.compareTo(tA);
      });

      return list;
    } catch (e) {
      debugPrint("Error in getTransactionsByRange: $e");
      return [];
    }
  }
}
