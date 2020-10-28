import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/signin/signin_viewmodel.dart';
import 'package:ctr/presentation/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  static const String routeName = "SignInScreen";

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).signIn)),
      body: ChangeNotifierProvider(
          create: (_) => SignInViewModel(),
          builder: (context, _) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  LoginForm(),
                  ElevatedButton.icon(
                      onPressed: () => context.googleSignIn(),
                      icon: SvgPicture.asset("assets/icons/google-icon.svg"),
                      label:
                          Text(AppLocalizations.of(context).signInWithGoogle),
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xfff7f7f7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)))),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).dontHaveAccount,
                      ),
                      InkWell(
                        onTap: () {
                          AppNavigator.of(context).push(MaterialPage(
                              name: SignUpScreen.routeName,
                              child: SignUpScreen()));
                        },
                        child: Text(
                          AppLocalizations.of(context).signUp,
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  )
                ],
              ))));
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).email,
                errorText: context
                    .select((SignInViewModel value) => value.emailError)),
            onChanged: (String value) =>
                context.read<SignInViewModel>().changeEmail(value, context),
          ),
          SizedBox(height: 16),
          TextField(
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (String value) =>
                context.read<SignInViewModel>().submit(context),
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).password,
                errorText: context
                    .select((SignInViewModel value) => value.passwordError)),
            onChanged: (String value) =>
                context.read<SignInViewModel>().changePassword(value, context),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                autofocus: true,
                onPressed: () =>
                    context.read<SignInViewModel>().submit(context),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
                ),
                child: Text(AppLocalizations.of(context).next),
              ),
            ),
          )
        ],
      );
}
