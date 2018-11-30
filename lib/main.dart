import 'dart:async';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_facebook_app/screens/DetailedScreen.dart'; //important fix
import 'package:flutter/material.dart';
import 'package:login_facebook_app/screens/login.dart';
import 'package:login_facebook_app/utils/colors.dart';
import 'package:login_facebook_app/screens/splash.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    // HomePage.tag: (context) => HomePage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kodeversitas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Nunito',
      ),
      home: SplashPage(),
      //routes: routes,
    );
  }
}

