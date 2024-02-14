import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppLocalizations? getAppLocalizations(BuildContext context) {
  return AppLocalizations.of(context);
}

Future<String?> translateErrorCodes(BuildContext context, String errorCode) async {
  var localization = AppLocalizations.of(context);
  var locale = Localizations.localeOf(context);
  String jsonString = await rootBundle
      .loadString('presentation/l10n/app_${locale.languageCode}.arb');
  Map<String, String> errorCodes = json.decode(jsonString);

  return errorCodes[errorCode];
}
