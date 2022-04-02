// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';

import 'screen/login_signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  //route de page suivante yaani to93od 6 secondes w baad tt7al lpage elli esmha LoginSignupScreen
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => LoginSignupScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(244, 1, 25, 59),
      // backgroundColor: Color.fromARGB(255, 74, 153, 153),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(isRepeatingAnimation: true, animatedTexts: [
              TyperAnimatedText('Communication Is Best,',
                  speed: Duration(milliseconds: 70),
                  textStyle: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              TyperAnimatedText('When It Helps People.',
                  speed: Duration(milliseconds: 70),
                  textStyle: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
            SizedBox(
              height: 500,
              width: 500,
              child: Lottie.network(
                  "https://assets6.lottiefiles.com/packages/lf20_p5yomfw6.json"),
            ),
            //https://assets9.lottiefiles.com/packages/lf20_q1g5qcgm.json
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
