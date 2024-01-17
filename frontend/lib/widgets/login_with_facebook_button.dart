import 'package:flutter/widgets.dart';
import 'package:frontend/utilities/custom_icons.dart';

import 'button.dart';

class LoginWithFacebookButton extends StatelessWidget {
  const LoginWithFacebookButton({super.key});

  @override
  Widget build(BuildContext context) => Button(
      text: "Continue with Facebook",
      onPressed: () {},
      icon: CustomIcons.facebook,
      iconSize: 24,
      iconColor: const Color.fromARGB(255, 19, 68, 231),
      textColor: const Color.fromARGB(255, 39, 39, 39),
      backgroundColor: const Color.fromARGB(255, 224, 224, 224),
      fontSize: 18);
}
