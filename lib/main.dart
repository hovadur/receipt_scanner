import 'package:flutter/material.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // https://stackoverflow.com/a/32686261/9449426
    final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return Scaffold(
      appBar: AppBar(leading: Icon(Icons.menu), title: Text("Authorization")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Email"),
                      validator: (String? value) {
                        if (value != null && !email.hasMatch(value)) {
                          return "Invalid email";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Password"),
                      validator: (String? value) {
                        if (value != null && value.length < 8) {
                          return "Must be > 7 characters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(
                          autofocus: true,
                          onPressed: () {
                            if (_formKey.currentState?.validate() == false) {
                              return null;
                            }
                          },
                          child: Text("Next"),
                        ),
                      ),
                    )
                  ],
                )),
            SignInButton(
                btnText: "Sign in with Google",
                buttonType: ButtonType.google,
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
