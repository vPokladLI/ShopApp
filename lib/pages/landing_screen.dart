import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './auth_screen.dart';
import './products_overview_screen.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    if (user?.uid != null) {
      return const ProductsOverviewScreen();
    } else {
      return const AuthScreen();
    }
  }
}
