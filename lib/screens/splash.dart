import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {

    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const login())),
    );
  }

  @override
  Widget build(BuildContext context) {


    AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark
    );

    return MaterialApp(


      debugShowCheckedModeBanner: false,
      home: Scaffold(

        backgroundColor: Colors.white,
        body: Center(
             child:  Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
  }