import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:toastification/toastification.dart';
import '../l10n/app_l10n.dart';

import '../utilities/custom_icons.dart';
import 'button.dart';

class LoginWithGoogleButton extends StatelessWidget {
  final Function? afterLoginContinuation;
  final Logger _logger = Logger();
  final _localization = Localization();
  LoginWithGoogleButton({Key? key, this.afterLoginContinuation = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizations = _localization.getAppLocalizations(context);

    return Button(
        text: localizations!.loginWithGoogle,
        onPressed: () async {
          List<String> scopes = [
            'email',
          ];
          GoogleSignIn googleSignIn = GoogleSignIn(
            scopes: scopes,
            forceCodeForRefreshToken: true,
            signInOption: SignInOption.standard,
          );
          try {
            GoogleSignInAccount? account = await googleSignIn.signIn();

            if (account == null) {
              return;
            }

            GoogleSignInAuthentication authentication =
                await account!.authentication;

            String? idToken = authentication.idToken;
            if (idToken == null) {
              _showError(context, localizations.errorLoginWithGoogle);
              return;
            }

            if (afterLoginContinuation != null) {
              await afterLoginContinuation!(idToken);
            }
          } catch (error) {
            _showError(context, localizations.errorLoginWithGoogle);
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

  void _showError(BuildContext context, String message) {
    toastification.show(
      context: context,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
      type: ToastificationType.error,
    );
  }
}
