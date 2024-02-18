import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/application/secure_storage/secure_storage.dart';
import 'package:frontend/domain/constants/app_constants.dart';
import 'package:frontend/domain/exceptions/application_exception.dart';
import 'package:frontend/main.dart';
import 'package:frontend/presentation/extensions/exception_extensions.dart';
import 'package:frontend/presentation/screens/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../application/services/user_service.dart';
import '../../domain/models/entities/auth_result.dart';
import '../../domain/models/entities/user_credentials.dart';
import '../l10n/app_l10n.dart';
import '../widgets/login_with_google_button.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/notifications/toast_notification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isEmailValid(String email) =>
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storage = SecureStorage();
  final _localization = Localization();
  bool _isLoading = false;
  bool _isFormValid = false;

  bool _areAllFieldsValid() {
    if (_emailController.text.isEmpty ||
        !_isEmailValid(_emailController.text)) {
      setState(() {
        _isFormValid = false;
      });
      return false;
    }
    if (_passwordController.text.isEmpty ||
        _passwordController.text.length < 5) {
      setState(() {
        _isFormValid = false;
      });
      return false;
    }
    setState(() {
      _isFormValid = true;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var localization = _localization.getAppLocalizations(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${localization!.dontHave("male")} ",
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                            fontFamily: "PTSansNarrow",
                            fontSize: 30,
                            color: Color.fromARGB(255, 43, 43, 43)),
                      ),
                      Text(
                        "${localization.account}?",
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                          fontFamily: "PTSansNarrow",
                          fontSize: 30,
                          color: Color.fromARGB(255, 39, 33, 234),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterScreen()));
                        },
                        child: Text(localization!.createAccount,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontFamily: "BricolageGrotesque",
                                fontSize: 20,
                                color: Color.fromARGB(255, 43, 43, 43))),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Form(
                key: _formKey,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(padding: EdgeInsets.all(5)),
                        FractionallySizedBox(
                            widthFactor: 0.9,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return localization.enterEmail;
                                }
                                if (!_isEmailValid(value)) {
                                  return localization.emailIsNotValid;
                                }
                                return null;
                              },
                              controller: _emailController,
                              onChanged: (value) {
                                _areAllFieldsValid();
                              },
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.email),
                                labelText: localization.email,
                                labelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 43, 43, 43)),
                              ),
                            )),
                        const Padding(padding: EdgeInsets.all(5)),
                        FractionallySizedBox(
                            widthFactor: 0.9,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return localization.enterPassword;
                                }
                                if (value.length < 5) {
                                  return localization.passwordMustBeAtLeast(5);
                                }
                                return null;
                              },
                              obscureText: true,
                              controller: _passwordController,
                              onChanged: (value) {
                                _areAllFieldsValid();
                              },
                              decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.lock),
                                border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 212, 212, 212))),
                                labelText: localization.password,
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 43, 43, 43),
                                ),
                              ),
                            )),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     Padding(
                        //         padding: EdgeInsets.only(right: 20, top: 10),
                        //         child: Consumer<LocaleModel>(
                        //             builder: (context, localeModel, child) =>
                        //                 GestureDetector(
                        //                   onTap: () {
                        //                     localeModel.setLocale(Locale(
                        //                         localeModel.locale ==
                        //                                 Locale('en')
                        //                             ? 'ro'
                        //                             : 'en'));
                        //                   },
                        //                   child: Text(
                        //                     Localization()
                        //                         .getAppLocalizations(context)!
                        //                         .forgotPassword,
                        //                     textAlign: TextAlign.right,
                        //                   ),
                        //                 )))
                        //   ],
                        // ),
                        const Padding(padding: EdgeInsets.all(5)),
                        Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: _isFormValid == true
                                    ? const LinearGradient(colors: [
                                        Color.fromARGB(255, 25, 77, 221),
                                        Color.fromARGB(255, 45, 3, 171),
                                      ])
                                    : const LinearGradient(colors: [
                                        Color.fromARGB(255, 128, 127, 127),
                                        Color.fromARGB(255, 128, 127, 127),
                                      ])),
                            child: ElevatedButton(
                                onPressed: _areAllFieldsValid() == true
                                    ? () async {
                                        try {
                                          if (_isLoading == true) {
                                            return;
                                          }
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          var result = await UserService.login(
                                              UserCredentials(
                                                  email: _emailController.text,
                                                  password: _passwordController
                                                      .text));

                                          _storage.insert(
                                              AppConstants.TOKEN, result.token);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ApplicationNavigationBar()));
                                        } on ApplicationException catch (e) {
                                          toastification.show(
                                            context: context,
                                            title: Text(localization
                                                .backend_error(e.getMessage)),
                                            autoCloseDuration:
                                                const Duration(seconds: 5),
                                            type: ToastificationType.error,
                                          );
                                        } finally {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(0, 52),
                                  elevation: 0,
                                  shape: const CircleBorder(eccentricity: 0),
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                ),
                                child: _isFormValid == true
                                    ? _isLoading == true
                                        ? const CircularProgressIndicator()
                                        : const Icon(
                                            color: Colors.white,
                                            Icons.arrow_right_alt_rounded,
                                            size: 40,
                                          )
                                    : const Icon(
                                        color: Color.fromARGB(255, 73, 73, 73),
                                        Icons.arrow_right_alt_rounded,
                                        size: 40,
                                      ))),
                        const Padding(padding: EdgeInsets.all(10)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            LoginWithGoogleButton(
                              afterLoginContinuation: (String googleToken) async {
                                try {
                                  var token = await UserService.registerWithGoogle(googleToken);
                                  await _afterSuccess(token.token, context);
                                } on ApplicationException catch (e) {
                                  ToastNotification.showError(context,
                                      localization.backend_error(e.getMessage));
                                }
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(10)),
                          ],
                        ),
                      ]),
                )),
          ]),
    );
  }

  Future<void> _afterSuccess(String token, BuildContext context) async {
    await _storage.insert(AppConstants.TOKEN, token);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ApplicationNavigationBar(),
      ),
    );
  }
}
