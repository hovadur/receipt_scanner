import 'package:ctr/domain/interactor/user_interactor.dart';
import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/camera/camera_screen.dart';
import 'package:ctr/presentation/signup/signup_viewmodel.dart';
import 'package:fimber/fimber_base.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = "SignUpScreen";

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).signUp)),
      body: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SignUpViewModel()),
            Provider(create: (_) => UserInteractor())
          ],
          builder: (context, _) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    LoginForm(),
                    ElevatedButton.icon(
                        onPressed: () async {
                          context
                              .read<UserInteractor>()
                              .signInWithGoogle()
                              .then((auth.User user) {
                            AppNavigator.of(context).clearAndPush(MaterialPage(
                                name: CameraScreen.routeName,
                                child: CameraScreen()));
                          }).catchError((e) => Fimber.e(e.toString()));
                        },
                        icon: SvgPicture.asset("assets/icons/google-icon.svg"),
                        label:
                            Text(AppLocalizations.of(context).signInWithGoogle),
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xfff7f7f7),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18))))
                  ],
                ),
              )));
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
                    .select((SignUpViewModel value) => value.emailError)),
            onChanged: (String value) =>
                context.read<SignUpViewModel>().changeEmail(value, context),
          ),
          SizedBox(height: 16),
          TextField(
            obscureText: true,
            textInputAction: TextInputAction.next,
            onSubmitted: (String value) =>
                context.read<SignUpViewModel>().submit(context),
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).password,
                errorText: context
                    .select((SignUpViewModel value) => value.passwordError)),
            onChanged: (String value) =>
                context.read<SignUpViewModel>().changePassword(value, context),
          ),
          SizedBox(height: 16),
          TextField(
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (String value) =>
                context.read<SignUpViewModel>().submit(context),
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).confirmPassword,
                errorText: context.select(
                    (SignUpViewModel value) => value.confirmPasswordError)),
            onChanged: (String value) => context
                .read<SignUpViewModel>()
                .changeConfirmPassword(value, context),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                autofocus: true,
                onPressed: () =>
                    context.read<SignUpViewModel>().submit(context),
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