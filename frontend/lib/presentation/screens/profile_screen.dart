import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/application/secure_storage/secure_storage.dart';
import 'package:frontend/domain/constants/app_constants.dart';
import 'package:frontend/main.dart';
import 'package:frontend/presentation/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../l10n/app_l10n.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final SecureStorage _storage = SecureStorage();
  final _localization = Localization();

  @override
  Widget build(BuildContext context) {
    var localization = _localization.getAppLocalizations(context);
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person,
            size: 100,
          ),
          ElevatedButton(
              onPressed: () async {
                await _storage.delete(AppConstants.ACCESS_TOKEN);
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false);
                }
              },
              child: Text(localization!.logout)),
          Consumer<LocaleModel>(builder: (context, localeModel, child) {
            return DropdownButton<String>(
              value: localeModel.locale?.languageCode == 'ro'
                  ? localization.romanian
                  : localization.english,
              borderRadius: BorderRadius.circular(10),
              items: <String>[localization.romanian, localization.english]
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                if (value == localization.romanian) {
                  localeModel.setLocale(const Locale('ro'));
                } else {
                  localeModel.setLocale(const Locale('en'));
                }
              },
            );
          }),
        ],
      ),
    ));
  }
}
