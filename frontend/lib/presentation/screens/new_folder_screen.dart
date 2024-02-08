import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/camera_screen.dart';

import '../l10n/app_l10n.dart';

class CreateNewFolderScreen extends StatefulWidget {
  const CreateNewFolderScreen({super.key});

  @override
  State<CreateNewFolderScreen> createState() => _CreateNewFolderScreenState();
}

class _CreateNewFolderScreenState extends State<CreateNewFolderScreen> {
  List<XFile> images = [];
  final _popupMenuKey = GlobalKey<PopupMenuButtonState>();
  List<String> values = [];
  String _dropdownValue = "";

  @override
  Widget build(BuildContext context) {
    var localization = getAppLocalizations(context);
    if(_dropdownValue == ""){
      _dropdownValue = localization!.carFromAnotherCountry;
    }
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: [
                DropdownButton(
                    value: _dropdownValue,
                    onChanged: (value) {
                      setState(() {
                        _dropdownValue = value.toString();
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
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
                ),
                PopupMenuButton(
                  position: PopupMenuPosition.under,
                  key: _popupMenuKey,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: localization.camera,
                        child: Row(
                          children: [
                            const Icon(Icons.camera_alt),
                            Text("\t${localization.camera}"),
                          ],
                        ),
                        onTap: () {
                          _onPopupMenuItemSelected(CameraScreen());
                        },
                      ),
                      PopupMenuItem(
                        value: localization.gallery,
                        child: Row(
                          children: [
                            const Icon(Icons.photo),
                            Text("\t${localization.gallery}"),
                          ],
                        ),
                        onTap: () {
                          _onPopupMenuItemSelected(CameraScreen());
                        },
                      ),
                    ];
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      _popupMenuKey.currentState!.showButtonMenu();
                    },
                    child: Text(localization.addImage),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.file(File(images[index].path),
                              fit: BoxFit.fitHeight, height: 125, width: 200),
                        ],
                      );
                    },
                    shrinkWrap: true,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Add folder to database
              },
              child: Text(localization!.submit),
            ),
          ],
        ),
      ),
    );
  }

  void _onDropdownItemSelected(String newValueSelected) {
    setState(() {
      print("aici " + newValueSelected);
      _dropdownValue = newValueSelected;
    });
  }

  void _onPopupMenuItemSelected(StatefulWidget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ).then((value) {
      if (value == null) {
        return;
      }
      _onPictureTaken(value as XFile);
    });
  }

  void _onPictureTaken(XFile picture) {
    setState(() {
      images.add(picture);
    });
  }
}
