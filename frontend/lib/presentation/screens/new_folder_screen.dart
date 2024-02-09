import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/domain/models/request/create_document.dart';
import 'package:frontend/domain/models/request/create_folder.dart';
import 'package:frontend/presentation/screens/camera_screen.dart';
import 'package:frontend/services/folder_service.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/app_l10n.dart';

class CreateNewFolderScreen extends StatefulWidget {
  const CreateNewFolderScreen({super.key});

  @override
  State<CreateNewFolderScreen> createState() => _CreateNewFolderScreenState();
}

class _CreateNewFolderScreenState extends State<CreateNewFolderScreen> {
  List<XFile> _images = [];
  final _popupMenuKey = GlobalKey<PopupMenuButtonState>();
  List<String> values = [];
  String _dropdownValue = "";
  final ImagePicker _imagePicker = ImagePicker();
  final FolderService _folderService = FolderService();

  @override
  Widget build(BuildContext context) {
    var localization = getAppLocalizations(context);
    if (_dropdownValue == "") {
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
                          _onGalleryImageSelected();
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
                  margin: const EdgeInsets.all(10),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 125,
                              child: Image.file(File(_images[index].path),
                                  fit: BoxFit.fill),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _images.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child: Text(localization!.submit),
              onPressed: () async {
                await _onSubmit();
              },
            ),
          ],
        ),
      ),
    );
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
      _images.add(picture);
    });
  }

  void _onGalleryImageSelected() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    setState(() {
      _images.add(image);
    });
  }

  Future<void> _onSubmit() async {
    var folder = CreateFolder(
      name: _dropdownValue,
      document: _images.map((e) => CreateDocument(image: e)).toList(),
    );

    try {
      await _folderService.createFolder(folder);
    } catch (e) {}
  }
}
