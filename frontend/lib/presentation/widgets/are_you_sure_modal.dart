import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/extensions/exception_extensions.dart';
import 'package:frontend/presentation/l10n/app_l10n.dart';
import 'package:frontend/presentation/widgets/notifications/toast_notification.dart';

class AreYouSureModal {
  static _getDialog(BuildContext dialogContext, BuildContext appContext,
      {Function? onYes = null, Function? onCancel = null}) {
    var localization = Localization().getAppLocalizations(appContext);
    bool _isLoading = false;
    return StatefulBuilder(
        builder: (BuildContext stateContext, StateSetter setState) {
      return Dialog(
        alignment: Alignment.center,
        child: SizedBox(
          height: MediaQuery.of(dialogContext).size.height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(localization!.areYouSure,
                    style: const TextStyle(fontSize: 17)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(125, 50)),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text(
                      localization.cancel,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(125, 50)),
                    onPressed: () async {
                      if (_isLoading == true) {
                        return;
                      }
                      if (onYes != null) {
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          await onYes();
                        } on Exception catch (e) {
                          ToastNotification.showError(appContext, e.getMessage);
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                      Navigator.of(dialogContext).pop();
                    },
                    child: _isLoading == false
                        ? Text(localization.yes)
                        : const CircularProgressIndicator(),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
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
