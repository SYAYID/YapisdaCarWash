import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tes/pages/login.dart';
import 'package:tes/widget/header_widget.dart';
import '../common/theme_helper.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  double _headerWidget = 250;
  Key _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _signUp() async {
    try {
      UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Jika sign up berhasil, lanjutkan ke halaman login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } on FirebaseAuthException catch (user) {
      if (user.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password terlalu lemah'),
          ),
        );
      } else if (user.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email sudah terdaftar'),
          ),
        );
      }
      // Handle error lainnya sesuai kebutuhan
    } catch (user) {
      print(user.toString());
    }
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
                      'Sign Up',
                      style: TextStyle(fontSize: 50 , fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Sign Up your account',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextField(
                            controller: _emailController,
                            decoration: ThemeHelper().textInputDecoration('Email', 'Enter your email'),
                          ),
                          SizedBox(height: 15.0),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                          ),
                          SizedBox(height: 15.0),

                          SizedBox(height: 15.0),
                          Container(
                            decoration: ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(context),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  'Sign Up'.toUpperCase(),
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                              onPressed: _signUp,
                            ),
                          ),
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 120, 20, 10),
                              child: Text(
                                '@Copyright 2023',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
