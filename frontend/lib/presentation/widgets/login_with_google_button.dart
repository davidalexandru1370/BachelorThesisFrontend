import 'package:flutter/material.dart';

import '../utilities/custom_icons.dart';
import 'button.dart';

class LoginWithGoogleButton extends StatelessWidget {
  const LoginWithGoogleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Button(
      text: "Continue with Google",
      onPressed: () {},
      icon: CustomIcons.google,
      iconSize: 24,
      iconColor: const Color.fromARGB(255, 19, 68, 231),
      textColor: const Color.fromARGB(255, 39, 39, 39),
      backgroundColor: const Color.fromARGB(255, 224, 224, 224),
      fontSize: 18);
}
