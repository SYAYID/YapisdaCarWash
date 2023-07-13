import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tes/pages/login.dart';
import 'package:tes/widget/header_widget.dart';
import '../common/theme_helper.dart';

class RPass extends StatefulWidget {
  const RPass({Key? key}) : super(key: key);

  @override
  State<RPass> createState() => _RPassState();
}

class _RPassState extends State<RPass> {
  double _headerWidget = 250;
  Key _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  void _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );
      // Jika email reset password berhasil dikirim, kembali ke halaman login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (user) {
      print(user.toString());
      // Handle error reset password sesuai kebutuhan
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
                      'Reset Password',
                      style: TextStyle(fontSize: 50 , fontWeight: FontWeight.bold),
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
                          Container(
                            decoration: ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(context),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  'Send'.toUpperCase(),
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                              onPressed: _resetPassword,
                            ),
                          ),
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 150, 20, 10),
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
