import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

enum UploadStatus { uploading, paused, completed, canceled, error }

class UploadFileItem {
  final File file;
  final String fileName;
  final double fileSizeKb;
  UploadTask? task;
  double progress;
  UploadStatus status;
  String? downloadUrl;

  UploadFileItem({
    required this.file,
    required this.fileName,
    required this.fileSizeKb,
    this.task,
    this.progress = 0.0,
    this.status = UploadStatus.uploading,
    this.downloadUrl,
  });
}
