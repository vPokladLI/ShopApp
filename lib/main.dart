import 'package:flutter/material.dart';
import './pages/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      theme: ThemeData(
          colorScheme: (ColorScheme.fromSwatch(
              primarySwatch: Colors.deepPurple,
              accentColor: Colors.deepOrange)),
          fontFamily: 'Lato',
          textTheme: const TextTheme(
              titleLarge: TextStyle(fontWeight: FontWeight.w700))),
      home: const ProductsOverviewScreen(),
      routes: {
        ProductsOverviewScreen.routName: (context) =>
            const ProductsOverviewScreen()
      },
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
