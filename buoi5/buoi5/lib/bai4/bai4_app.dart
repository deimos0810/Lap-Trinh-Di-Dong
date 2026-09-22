import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';
import 'screens/store_screen.dart';
import 'screens/cart_screen.dart';

class Bai4App extends StatefulWidget {
  const Bai4App({super.key});

  @override
  State<Bai4App> createState() => _Bai4AppState();
}

class _Bai4AppState extends State<Bai4App> {
  // 'intro' | 'store' | 'cart'
  String _currentScreen = 'intro';

  void _navigateTo(String screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case 'intro':
        return IntroScreen(
          onStartApp: () => _navigateTo('store'),
        );
      case 'cart':
        return CartScreen(
          onNavigateToStore: () => _navigateTo('store'),
          onNavigateToIntro: () => _navigateTo('intro'),
        );
      case 'store':
      default:
        return StoreScreen(
          onNavigateToCart: () => _navigateTo('cart'),
          onNavigateToIntro: () => _navigateTo('intro'),
        );
    }
  }
}
