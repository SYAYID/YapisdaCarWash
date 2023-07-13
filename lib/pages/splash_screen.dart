import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tes/pages/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.title});
  final String title;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool _isVisible = false;

  _SplashScreenState(){
    new Timer(Duration( milliseconds: 3500),(){
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
      });
  });
    new Timer(
        Duration(milliseconds: 10), () {
          setState(() {
            _isVisible = true;
          });

    });

}

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.secondary, Theme.of(context).primaryColor ],
          begin: const FractionalOffset(0, 0),
          end:  const FractionalOffset(1.0, 0),
          stops: [0.0,1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0,
          duration: const Duration(milliseconds: 100),
        child: Center(
          child: Container(
            height: 400.0,
            width: 400.0,
            child: Image.asset(
                'assets/images/5.png',
                    fit: BoxFit.cover,
            ),
          ),
        ),
      )
    );
  }
}
