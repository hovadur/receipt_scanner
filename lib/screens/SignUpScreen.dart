import 'package:flutter/material.dart';
import 'package:ctr/l10n/app_localizations.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).signUp))
  );
}
