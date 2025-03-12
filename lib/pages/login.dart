import 'package:animate_gradient/animate_gradient.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:ytsync/main.dart';
import 'package:ytsync/network.dart';
import 'package:ytsync/pages/forgotpassword.dart';
import 'package:ytsync/pages/homepage.dart';
import 'package:ytsync/util.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  LogInPageState createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  LogInPageState();

  bool loginPage = true;

  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _passText = TextEditingController();
  final TextEditingController _nameText = TextEditingController();
  final TextEditingController _confirmPassText = TextEditingController();

  final ForgotPasswordPage forgotPassPage = ForgotPasswordPage();

  bool loginButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var titleStyle =
        theme.textTheme.titleMedium?.copyWith(
          fontFamily: "Pirata One",
          fontSize: 100.0,
        ) ??
        TextStyle(fontFamily: "Pirata One", fontSize: 100.0);

    var logInText = (loginPage ? "Log In" : "Sign Up").padRight(23);
    logInText = logInText.padLeft(40);

    return Scaffold(
      body: AnimateGradient(
        primaryBegin: Alignment.topLeft,
        primaryEnd: Alignment.bottomLeft,
        secondaryBegin: Alignment.bottomRight,
        secondaryEnd: Alignment.topLeft,
        primaryColors: const [
          Color.fromARGB(255, 206, 251, 251),
          Color.fromARGB(255, 253, 230, 187),
        ],
        secondaryColors: const [
          Color.fromARGB(255, 253, 230, 187),
          Color.fromARGB(255, 206, 251, 251),
        ],
        duration: Duration(seconds: 15),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: AnimatedTextKit(
                        animatedTexts: [
                          ColorizeAnimatedText(
                            'Welcome to YTSync!',
                            textStyle: titleStyle,
                            colors: [Colors.purpleAccent, Colors.blueAccent],
                          ),
                        ],
                        isRepeatingAnimation: false,
                      ),
                    ),
                  ),
                  Text(
                    loginPage ? "Please log in below." : "Please sign up below",
                    style: TextStyle(fontFamily: "Pacifico"),
                  ),

                  SizedBox(height: 50.0),

                  SizedBox(
                    width: 350.0,
                    child: Column(
                      spacing: 15.0,
                      children: [
                        loginPage
                            ? SizedBox()
                            : TextField(
                              controller: _nameText,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Username',
                              ),
                            ),
                        TextField(
                          controller: _emailText,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Email',
                          ),
                        ),
                        TextField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: _passText,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Password',
                          ),
                        ),
                        loginPage
                            ? SizedBox()
                            : TextField(
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              controller: _confirmPassText,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Confirm Password',
                              ),
                            ),
                        Row(
                          children: [
                            loginPage
                                ? TextButton(
                                  onPressed: () {
                                    Navigator.push(context, 
                                      MaterialPageRoute(
                                        builder: (context) => forgotPassPage,
                                      )
                                    );
                                  },
                                  child: Text(
                                    "Forgot Password",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                                : SizedBox(),
                          ],
                        ),

                        TextButton(
                          onPressed: () async {
                            if (loginButtonDisabled) {
                              return;
                            }

                            if (!loginPage && _nameText.text.isEmpty) {
                              showSnackBar(
                                context,
                                "Please fill in your username.",
                              );
                              return;
                            }

                            if (_emailText.text.isEmpty) {
                              showSnackBar(
                                context,
                                "Please fill in your email.",
                              );
                              return;
                            }

                            if (_passText.text.isEmpty) {
                              showSnackBar(
                                context,
                                "Please fill in your password.",
                              );
                              return;
                            } else if (!loginPage) {
                              if (_passText.text.length < 8) {
                                showSnackBar(
                                  context,
                                  "Password must be at least 8 characters long.",
                                );
                                return;
                              } else if (!RegExp(
                                    r'[a-zA-Z]',
                                  ).hasMatch(_passText.text) ||
                                  !RegExp(r'\d').hasMatch(_passText.text)) {
                                showSnackBar(
                                  context,
                                  "Password must have at least one alphabet and one number.",
                                );
                                return;
                              }
                            }

                            if (!loginPage) {
                              if (_confirmPassText.text.isEmpty) {
                                showSnackBar(
                                  context,
                                  "Please confirm your password.",
                                );
                                return;
                              } else if (_confirmPassText.text !=
                                  _passText.text) {
                                showSnackBar(
                                  context,
                                  "Passwords do not match. Retype 'Confirm Password'.",
                                );
                                return;
                              }
                            }

                            showSnackBar(
                              context,
                              loginPage
                                  ? "Logging in. Please wait."
                                  : "Signing you up! Please wait.",
                            );
                            loginButtonDisabled = true;
                            var result = await firebaseInit(
                              true,
                              _emailText.text,
                              _passText.text,
                              loginPage ? null : _nameText.text,
                            );
                            if (result.$1) {
                              if (context.mounted) {
                                showSnackBar(
                                  context,
                                  loginPage
                                      ? "Login success!"
                                      : "Sign up success. Welcome to YTSync!",
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              }
                            } else if (context.mounted) {
                              showSnackBar(context, result.$2);
                            }
                            loginButtonDisabled = false;
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.amberAccent,
                            ),
                          ),
                          child: Text(logInText),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        loginPage = !loginPage;
                      });
                    },
                    child: Text(
                      loginPage
                          ? "Don't have an account? Sign up instead."
                          : "Log in instead.",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
