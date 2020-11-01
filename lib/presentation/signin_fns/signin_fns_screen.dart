import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/signin_fns/signin_fns_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignInFnsScreen extends StatelessWidget {
  const SignInFnsScreen({@required this.onPressed, Key key}) : super(key: key);
  static const String routeName = 'SignInFnsScreen';

  final Function onPressed;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).fnsAccount)),
      body: ChangeNotifierProvider(
          create: (_) => SignInFnsViewModel(),
          builder: (context, _) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Text(AppLocalizations.of(context).ftsWarning),
                  LoginForm(onPressed: onPressed),
                ],
              ))));
}

class LoginForm extends StatelessWidget {
  const LoginForm({@required this.onPressed, Key key}) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            keyboardType: const TextInputType.numberWithOptions(),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).inn,
                errorText: context
                    .select((SignInFnsViewModel value) => value.innError)),
            onChanged: (String value) =>
                context.read<SignInFnsViewModel>().changeEmail(value, context),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (String value) => submit(context),
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).password,
                errorText: context
                    .select((SignInFnsViewModel value) => value.passwordError)),
            onChanged: (String value) => context
                .read<SignInFnsViewModel>()
                .changePassword(value, context),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                autofocus: true,
                onPressed: () => submit(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 4.0),
                ),
                child: Text(AppLocalizations.of(context).next),
              ),
            ),
          )
        ],
      );

  void submit(BuildContext context) {
    context.read<SignInFnsViewModel>().submit(context).then((value) {
      if (value) {
        onPressed();
        AppNavigator.of(context).pop();
      } else {
        context.showError(AppLocalizations.of(context).invalidCredentials);
      }
    });
  }
}
