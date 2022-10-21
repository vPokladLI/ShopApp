import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/products_overview_screen.dart';
import './pages/product_detailed_screen.dart';
import './pages/cart_screen.dart';
import './pages/order_screen.dart';
import './pages/user_products_screen.dart';
import './pages/edit_product_screen.dart';
import './pages/auth_screen.dart';

import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Products()),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => Orders()),
      ],
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
            colorScheme: (ColorScheme.fromSwatch(
                primarySwatch: Colors.deepPurple,
                accentColor: Colors.deepOrange)),
            fontFamily: 'Lato',
            textTheme: const TextTheme(
                titleLarge: TextStyle(fontWeight: FontWeight.w700))),
        home: const AuthScreen(),
        routes: {
          ProductsOverviewScreen.routName: (context) =>
              const ProductsOverviewScreen(),
          ProductDetailedScreen.routName: (context) =>
              const ProductDetailedScreen(),
          CartScreen.routName: (context) => const CartScreen(),
          OrderScreen.routName: (context) => const OrderScreen(),
          UserProductsScreen.routName: (context) => const UserProductsScreen(),
          EditProductScreen.routName: (context) => const EditProductScreen(),
        },
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App bar')),
      body: const Center(
        child: Text('Running'),
      ),
    );
  }
}
