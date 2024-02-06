import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/common.dart';

class CreateNewFolderScreen extends StatefulWidget {
  const CreateNewFolderScreen({super.key});

  @override
  State<CreateNewFolderScreen> createState() => _CreateNewFolderScreenState();
}

class _CreateNewFolderScreenState extends State<CreateNewFolderScreen> {
  @override
  Widget build(BuildContext context) {
    var localization = getAppLocalizations(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DropdownButton(
              items: [
                DropdownMenuItem(
                  value: localization!.carFromAnotherCountry,
                  child: Text(localization.carFromAnotherCountry),
                ),
                DropdownMenuItem(
                  value: localization.carNeverRegistered,
                  child: Text(localization.carNeverRegistered),
                ),
                DropdownMenuItem(
                  value: localization.carRegisteredInCountry,
                  child: Text(localization.carRegisteredInCountry),
                ),
              ],
              onChanged: (value) {
                _onDropdownItemSelected(value as String);
              }),
          ElevatedButton(
            onPressed: () {
              // Add folder to database
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _onDropdownItemSelected(String newValueSelected) {}
}
