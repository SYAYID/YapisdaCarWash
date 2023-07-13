import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tes/pages/forgot_password.dart';
import 'package:tes/pages/home_page.dart';
import 'package:tes/pages/signup.dart';
import 'package:tes/widget/header_widget.dart';
import '../common/theme_helper.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  double _headerWidget = 250;
  Key _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _signIn() async {
    try {
      UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Jika login berhasil, lanjutkan ke halaman beranda
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (user) {
      if (user.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email tidak ditemukan'),
          ),
        );
      } else if (user.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password salah'),
            backgroundColor: Colors.red,
          ),
        );
      }
      // Handle error lainnya sesuai kebutuhan
    }
  }
  InputDecoration _buildPasswordInputDecoration() {
    return InputDecoration(
      labelText: 'Password',
      hintText: 'Enter your password',
      fillColor: Colors.white,
      labelStyle: TextStyle(color: Colors.black),
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.0),
        borderSide: BorderSide(color: Colors.black),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.0),
        borderSide: BorderSide(color: Colors.black),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.0),
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.0),
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
      suffixIcon: IconButton(
        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerWidget,
              child: HeaderWidget(_headerWidget, true, Icons.local_car_wash_sharp),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(fontSize: 50 , fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Sign in to your account',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextField(
                            controller: _emailController,
                            decoration: ThemeHelper().textInputDecoration('Email ', 'Enter your email'),
                          ),
                          SizedBox(height: 15.0),
                          TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: _buildPasswordInputDecoration(),
                          ),
                          SizedBox(height: 15.0),
                          InkWell(
                            child: Text(
                                'Forgot password?',
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RPass()),
                              );
                            },
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            decoration: ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(context),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  'Sign In'.toUpperCase(),
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                              onPressed: _signIn,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(40, 60, 40, 10),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignUp()),
                              );
                            },
                            child: Text.rich(
                              TextSpan(
                                text: "Don't have an account?",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(
                                    text: " Sign Up",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                              child: Text(
                                '@Copyright 2023',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
