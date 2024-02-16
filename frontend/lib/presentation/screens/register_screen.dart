import 'package:flutter/material.dart';
import 'package:frontend/domain/constants/app_constants.dart';
import 'package:frontend/domain/exceptions/application_exception.dart';
import 'package:frontend/presentation/extensions/exception_extensions.dart';
import 'package:frontend/presentation/widgets/navigation_bar.dart';
import 'package:frontend/presentation/widgets/notifications/toast_notification.dart';

import '../../application/secure_storage/secure_storage.dart';
import '../../application/services/user_service.dart';
import '../../domain/models/entities/user_credentials.dart';
import '../l10n/app_l10n.dart';
import '../widgets/login_with_google_button.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterForm();
}

class _RegisterForm extends State<RegisterScreen> {
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
                        "${localization!.alreadyHaveAccount}",
                        style: const TextStyle(
                            fontFamily: "PTSansNarrow",
                            fontSize: 30,
                            color: Color.fromARGB(255, 43, 43, 43)),
                      ),
                      Text(
                        "${localization!.account}?",
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
                                  builder: (context) => const LoginScreen()));
                        },
                        child: Text(localization!.connectNow,
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
                                suffixIcon: const Icon(Icons.email),
                                labelText: localization!.email,
                                labelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 43, 43, 43)),
                              ),
                            )),
                        const Padding(padding: EdgeInsets.all(5)),
                        FractionallySizedBox(
                            widthFactor: 0.9,
                            child: TextFormField(
                              validator: (value) {
                                const int minPasswordLength = 5;
                                if (value == null || value.isEmpty) {
                                  return localization.enterPassword;
                                }
                                if (value.length < minPasswordLength) {
                                  return localization
                                      .passwordMustBeAtLeast(minPasswordLength);
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
                                labelText: localization!.password,
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 43, 43, 43),
                                ),
                              ),
                            )),
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
                                        if (_isLoading == true) {
                                          return;
                                        }
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        try {
                                          var authResult = await UserService
                                              .register(UserCredentials(
                                                  email: _emailController.text,
                                                  password: _passwordController
                                                      .text));
                                          await _afterSuccess(
                                              authResult.token, context);
                                        } on ApplicationException catch (e) {
                                          ToastNotification.showError(
                                              context,
                                              localization
                                                  .backend_error(e.getMessage));
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
                              afterLoginContinuation: (String token) async {
                                try {
                                  await UserService.registerWithGoogle(token);
                                  await _afterSuccess(token, context);
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
