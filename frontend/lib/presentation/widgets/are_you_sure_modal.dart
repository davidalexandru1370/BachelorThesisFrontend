import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/l10n/app_l10n.dart';

class AreYouSureModal {
  static _getDialog(BuildContext context,
      {Function? onYes = null, Function? onCancel = null}) {
    var localization = Localization().getAppLocalizations(context);
    return Dialog(
      child: Column(
        children: [
          Text(localization!.areYouSure),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(localization.no),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(localization.yes),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static displayDialog(BuildContext context,
      {Function? onYes, Function? onCancel}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _getDialog(context, onYes: onYes, onCancel: onCancel);
      },
    );
  }
}
