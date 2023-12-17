import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myclasses/src/utils/localization/l10n.dart';
import 'package:myclasses/src/utils/widgets/error/dialog_mixin.dart';
import 'package:myclasses/src/utils/widgets/text_input/email_field.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:turu/features/login/forgot_password_page.dart';
// import 'package:turu/features/login/widgets/email_field.dart';
// import 'package:turu/l10n/l10n.dart';

// import '../../common/assets/assets.gen.dart';
// import '../../error/dialog_mixin.dart';
// import '../settings/settings_page.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const route = '/';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _email, _password;
  bool isHidden = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: SvgPicture.asset(
              //     Assets.svgs.headerImage,
              //     colorFilter: ColorFilter.mode(
              //       theme.colorScheme.onPrimaryContainer,
              //       BlendMode.srcIn,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 160),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.background,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: AutofillGroup(
                      child: SingleChildScrollView(
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 80),
                            Text(
                              l10n.login,
                              style: theme.textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 16),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: l10n.noAccount,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  TextSpan(
                                    text: ' ${l10n.signUp}',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                    mouseCursor: SystemMouseCursors.click,
                                    // recognizer: TapGestureRecognizer()
                                    //   ..onTap = () =>
                                    //       context.goNamed(SettingsPage.route),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            EmailField(onSaved: (input) => _email = input),
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => signIn(),
                              autofillHints: const <String>[
                                AutofillHints.password
                              ],
                              onEditingComplete: () =>
                                  TextInput.finishAutofillContext(),
                              validator: (input) {
                                if (input == null || input.length < 6) {
                                  return l10n.weakPassword;
                                }
                                return null;
                              },
                              onSaved: (input) => _password = input,
                              decoration: InputDecoration(
                                labelText: l10n.password,
                                suffixIcon: IconButton(
                                  onPressed: () =>
                                      setState(() => isHidden = !isHidden),
                                  icon: isHidden
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off),
                                ),
                              ),
                              obscureText: isHidden,
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  _formKey.currentState!.save();
                                  // context.pushNamed(
                                  //   ForgotPasswordPage.route,
                                  //   queryParameters: {'email': _email},
                                  // );
                                },
                                child: Text(l10n.forgotPassword),
                              ),
                            ),
                            const SizedBox(height: 24),
                            OutlinedButton(
                              onPressed: signIn,
                              child: Text(l10n.signIn),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            OutlinedButton(
                              onPressed: register,
                              child: Text(l10n.siginUp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      TextInput.finishAutofillContext();
      final l10n = context.l10n;
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );
        log(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          log('The password provided is too weak.');
          log(e.toString());
          if (!mounted) return;
          dialogError(context: context, error: l10n.weakPassword);
        } else if (e.code == 'email-already-in-use') {
          log('The account already exists for that email.');
          log(e.toString());
          // Dialogs.error(
          //   context,
          //   error: l10n.emailRegisteredError,
          // );
        }
      } catch (e) {
        log(e.toString());
        // Dialogs.error(context, error: e.toString());
      }
    }
  }

  Future<void> signIn() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        TextInput.finishAutofillContext();
        try {
          final credential = await auth.signInWithEmailAndPassword(
            email: _email!,
            password: _password!,
          );
          log(credential.user?.uid ?? '');
          // Successfully signed in
          // You can navigate to another screen here
        } catch (e) {
          log(e.toString());
          // Dialogs.error(context, error: context.l10n.invalidLogin);
        }
      }
  }
}
