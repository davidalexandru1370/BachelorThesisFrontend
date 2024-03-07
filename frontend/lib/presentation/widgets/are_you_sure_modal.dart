import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/l10n/app_l10n.dart';

class AreYouSureModal {
  static _getDialog(BuildContext dialogContext, BuildContext appContext,
      {Function? onYes = null, Function? onCancel = null}) {
    var localization = Localization().getAppLocalizations(appContext);
    return Dialog(
      alignment: Alignment.center,
      child: SizedBox(
        height: MediaQuery.of(dialogContext).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localization!.areYouSure),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(localization.cancel),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(localization.yes),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static displayDialog(BuildContext context,
      {Function? onYes, Function? onCancel}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return _getDialog(dialogContext, context,
            onYes: onYes, onCancel: onCancel);
      },
    );
  }
}
