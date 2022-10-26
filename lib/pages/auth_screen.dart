import 'dart:math';

import 'package:flutter/material.dart';
import '../services/auth_service.dart';

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
  final Auth _auth = Auth();
  var _isLoading = false;
  var _passwordVisible = true;
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {'email': '', 'password': ''};
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_authMode == AuthMode.login) {
      _auth
          .loginWithEmailPassword(_authData['email']!, _authData['password']!)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });

// login
    } else {
      _auth
          .registerWithEmailPassword(
              _authData['email']!, _authData['password']!)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8,
      child: Container(
        height: _authMode == AuthMode.login ? 300 : 380,
        width: size.width * 0.75,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.login ? 260 : 320),
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(label: Text('E-mail')),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'e-mail is not valid';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _authData['email'] = newValue!.trim();
                      },
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      obscureText: _passwordVisible,
                      decoration: InputDecoration(
                        label: const Text('Password'),
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Password length must be at least 6 characters';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _authData['password'] = newValue!.trim();
                      },
                    ),
                    if (_authMode == AuthMode.signUp)
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        obscureText: _passwordVisible,
                        enabled: _authMode == AuthMode.signUp,
                        decoration: InputDecoration(
                          label: const Text('Confirm password'),
                          suffixIcon: IconButton(
                            icon: Icon(_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        validator: _authMode == AuthMode.signUp
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords are not equal';
                                }
                                return null;
                              }
                            : null,
                        onEditingComplete: _submitForm,
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (_isLoading) const CircularProgressIndicator(),
                    if (!_isLoading)
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15)),
                          onPressed: _submitForm,
                          child: Text(_authMode == AuthMode.login
                              ? 'Login'
                              : 'Register')),
                    TextButton(
                        onPressed: _switchAuthMode,
                        child: Text(
                          _authMode == AuthMode.login
                              ? 'Don\'t have account? Register!'
                              : 'Already have account? Login!',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        )),
                  ]),
            )),
      ),
    );
  }
}
