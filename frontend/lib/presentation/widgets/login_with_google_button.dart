import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

import '../utilities/custom_icons.dart';
import 'button.dart';

class LoginWithGoogleButton extends StatelessWidget {
  LoginWithGoogleButton({Key? key}) : super(key: key);
  final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) => Button(
      text: "Continue with Google",
      onPressed: () async {
        List<String> scopes = [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly'
        ];
        GoogleSignIn googleSignIn = GoogleSignIn(
          scopes: scopes,
        );
        try {
          GoogleSignInAccount? account = await googleSignIn.signIn();
          print(account?.email);
        } catch (error) {
          _logger.log(Level.error, error);
        }
      },
      icon: CustomIcons.google,
      iconSize: 24,
      iconColor: const Color.fromARGB(255, 19, 68, 231),
      textColor: const Color.fromARGB(255, 39, 39, 39),
      backgroundColor: const Color.fromARGB(255, 224, 224, 224),
      fontSize: 18);
}
