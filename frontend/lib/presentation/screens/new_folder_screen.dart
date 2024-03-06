import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/application/websocket/web_socket.dart';
import 'package:frontend/domain/models/entities/create_folder_notification.dart';
import 'package:frontend/domain/models/entities/request/create_document.dart';
import 'package:frontend/domain/models/entities/request/create_folder.dart';
import 'package:frontend/presentation/screens/camera_screen.dart';
import 'package:frontend/presentation/widgets/notifications/toast_notification.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

import '../../application/secure_storage/secure_storage.dart';
import '../../application/services/folder_service.dart';
import '../../domain/constants/api_constants.dart';
import '../../domain/constants/app_constants.dart';
import '../../domain/exceptions/unauthenticated_exception.dart';
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
  final WebSocketConnection _webSocketConnection = WebSocketConnection.instance;
  CreateFolderNotification _notification = CreateFolderNotification();
  StateSetter? _setModalState;
  var _localization = Localization();

  @override
  Widget build(BuildContext context) {
    var localization = _localization.getAppLocalizations(context);
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
                _showModalAfterUpload(context);
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

  void _showModalAfterUpload(BuildContext context) {
    var localization = _localization.getAppLocalizations(context);
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          _setModalState = setModalState;
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localization!.uploadImage,
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      _notification.imagesUploaded == null
                          ? const CircularProgressIndicator()
                          : _notification.imagesUploaded == true
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(localization!.analyzeDocument,
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold)),
                        _notification.documentsAnalyzed == null
                            ? const CircularProgressIndicator()
                            : _notification.documentsAnalyzed == true
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                      ])
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> _onSubmit() async {
    var folder = CreateFolder(
      name: _dropdownValue,
      document: _images.map((e) => CreateDocument(image: e)).toList(),
    );
    try {
      SecureStorage _storage = SecureStorage();
      var hubConnection = HubConnectionBuilder()
          .withUrl(
              ApiConstants.WEBSOCKET_URL + "/hubs/createFolder/notification",
              options: HttpConnectionOptions(
                  requestTimeout: 90000,
                  logMessageContent: true,
                  accessTokenFactory: () async => await _storage.readOrThrow(
                      AppConstants.ACCESS_TOKEN, UnauthenticatedException())))
          .build();
      await hubConnection.start();
      hubConnection!.on("SendNewStatus", (arguments) {
        var notification = CreateFolderNotification.fromMap(
            arguments![0] as Map<String, dynamic>);
        Logger().log(Level.info, "Received message: $notification");
        _setModalState!(() {
          _notification = notification;
        });
      });
      await _folderService.createFolder(folder);
      Navigator.pop(context);
      Navigator.pop(context);
    } on TimeoutException {
    } catch (e) {
      Logger().log(Level.error, "Error: $e");
      ToastNotification.showError(context, e.toString());
    }
  }
}
