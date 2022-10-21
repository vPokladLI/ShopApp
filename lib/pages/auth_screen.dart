import 'dart:math';

import 'package:flutter/material.dart';

enum AuthMode { signUp, login }

class AuthScreen extends StatelessWidget {
  static const routName = '/auth';
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final deviceSize = media.size;
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 0.5),
                  Color.fromRGBO(255, 188, 117, 0.9)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1]),
          ),
        ),
        SingleChildScrollView(
          child: SizedBox(
            width: deviceSize.width,
            height: deviceSize.height,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 94),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade900,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2))
                        ],
                      ),
                      child: const Text(
                        'My shop',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontFamily: 'Anton',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Flexible(
                      flex: deviceSize.width > 600 ? 2 : 1,
                      child: const AuthCard())
                ]),
          ),
        )
      ]),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  Map<String, String> _authData = {'email': '', 'password': ''};
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
