// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_podcast/services/auth_service.dart';
import 'package:flutter_podcast/utils/constants.dart';
import 'package:flutter_podcast/utils/theme_utils.dart';
import 'package:flutter_podcast/widgets/constants.dart';
import 'package:flutter_podcast/widgets/flutter_podcast_error_widget.dart';
import 'package:flutter_podcast/widgets/flutter_podcast_text_field.dart';

enum SignTypeScreen { signIn, signUp }

class SignInOut extends StatefulWidget {
  /// will change the view according the sign type screen, if sign in then will
  /// show the sign in dialogs and adjust accordingly
  final SignTypeScreen signTypeScreen;
  final bool showOtherSignScreen;
  const SignInOut({
    Key? key,
    required this.signTypeScreen,
    required this.showOtherSignScreen,
  }) : super(key: key);

  @override
  State<SignInOut> createState() => _SignInOutState();
}

class _SignInOutState extends State<SignInOut> {
  static const _validEmail = 'PCELIS19@GMAIL.COM';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  bool _isLoading = false;
  bool _hidePassword = true;
  String? _emailErrorText;
  String? _passwordErrorText;
  late SignTypeScreen _signTypeScreen;

  @override
  void initState() {
    super.initState();
    _signTypeScreen = widget.signTypeScreen;
    _emailController
        .addListener(() => updateEmailErrorText(_emailController.text));
    _passwordController
        .addListener(() => updatePasswordErrorText(_passwordController.text));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// if screen is the Sign In
  bool get isSignInScreen => _signTypeScreen == SignTypeScreen.signIn;

  /// will change the loading screen
  void setLoading(bool loadingState) {
    if (mounted) {
      setState(() {
        _isLoading = loadingState;
      });
    }
  }

  /// the functionality of the submit button
  void submit() async {
    setLoading(true);
    try {
      final email = _emailController.text;
      final password = _passwordController.text;
      if (isSignInScreen) {
        await AuthService.signIn(email: email, password: password);
      } else {
        await AuthService.signUp(email: email, password: password);
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => FlutterPodcastErrorWidget(error: e),
      );
    }
    setLoading(false);
    FocusScope.of(context).requestFocus(_emailNode);
  }

  /// gives the header depending on view type
  String get headerText => isSignInScreen ? 'Sign In' : 'Register';

  /// error text for email
  void updateEmailErrorText(String value) {
    if (value.toUpperCase() != _validEmail) {
      setState(() {
        _emailErrorText = 'enter valid email';
      });
    } else {
      setState(() {
        _emailErrorText = null;
      });
    }
  }

  void updatePasswordErrorText(String value) {
    if (value.length < 8) {
      setState(() {
        _passwordErrorText = 'enter a stronger password';
      });
    } else {
      setState(() {
        _passwordErrorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(),
        body: Center(
          child: SimpleDialog(
            title: AnimatedSwitcher(
              duration: duration600ms,
              child: Text(
                headerText,
                key: ValueKey<String>(headerText),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlutterPodcastTextField(
                  focusNode: _emailNode,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'fooBar@flutter.io.com',
                  labelText: 'email',
                  errorText: _emailErrorText,
                  onSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_passwordNode),
                  textInputAction: TextInputAction.next,
                  controller: _emailController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlutterPodcastTextField(
                  keyboardType: TextInputType.visiblePassword,
                  focusNode: _passwordNode,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    },
                    icon: Icon(_hidePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                  hintText: null,
                  onSubmitted: _isLoading ? null : (_) => submit.call(),
                  errorText: _passwordErrorText,
                  labelText: 'password',
                  textInputAction: TextInputAction.done,
                  controller: _passwordController,
                  obscureText: _hidePassword,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : submit,
                  child: AnimatedSwitcher(
                      duration: duration600ms,
                      child: Text(
                        headerText,
                        key: ValueKey<String>(headerText),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: kToolbarHeight,
                  child: AnimatedSwitcher(
                    duration: duration600ms,
                    child: _isLoading
                        ? Center(
                            child: Column(
                            children: [
                              Text(
                                'working',
                                style: getTheme(context).textTheme.overline,
                              ),
                              h8SizedBox,
                              const LinearProgressIndicator(),
                            ],
                          ))
                        : Container(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedSwitcher(
                  duration: duration600ms,
                  child: Row(
                    key: ValueKey<String>(headerText),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isSignInScreen
                            ? 'Do not have an account? '
                            : 'Already have an account?',
                        style: getTheme(context).textTheme.caption,
                      ),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_signTypeScreen == SignTypeScreen.signIn) {
                                  setState(() {
                                    _signTypeScreen = SignTypeScreen.signUp;
                                  });
                                } else {
                                  setState(() {
                                    _signTypeScreen = SignTypeScreen.signIn;
                                  });
                                }
                              },
                        child: Text(
                          isSignInScreen ? 'register' : 'sign in',
                          style: getTheme(context).textTheme.caption,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
