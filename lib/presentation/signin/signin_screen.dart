import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/signin/signin_viewmodel.dart';
import 'package:ctr/presentation/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:websafe_svg/websafe_svg.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static const String routeName = 'SignInScreen';

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(context.translate().signIn)),
      body: ChangeNotifierProvider(
          create: (_) => SignInViewModel(),
          builder: (context, _) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const LoginForm(),
                  ElevatedButton.icon(
                      onPressed: () => context.googleSignIn(),
                      icon: WebsafeSvg.asset('assets/icons/google-icon.svg'),
                      label: Text(context.translate().signInWithGoogle),
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xfff7f7f7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)))),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.translate().dontHaveAccount,
                      ),
                      InkWell(
                        onTap: () {
                          AppNavigator.of(context).push(
                              const MaterialPage<Page>(
                                  name: SignUpScreen.routeName,
                                  child: SignUpScreen()));
                        },
                        child: Text(
                          context.translate().signUp,
                          style: const TextStyle(
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
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: context.translate().email,
                errorText: context
                    .select((SignInViewModel value) => value.emailError)),
            onChanged: (String value) =>
                context.read<SignInViewModel>().changeEmail(value, context),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (String value) => submit(context),
            decoration: InputDecoration(
                labelText: context.translate().password,
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
                onPressed: () => submit(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 4.0),
                ),
                child: Text(context.translate().cont),
              ),
            ),
          )
        ],
      );

  void submit(BuildContext context) {
    context.read<SignInViewModel>().submit(context);
  }
}
