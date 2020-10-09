import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_login/flutter_login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)),
      darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(loginProvidersList: [
      LoginProvider(icon: Icons.ac_unit, callback: (){
        return Future.delayed(Duration(milliseconds: timeDilation.ceil() * 2250)).then((value) => "null");
      })
    ], onSignup: null, onLogin: null, onRecoverPassword: null);
  }
  
}
