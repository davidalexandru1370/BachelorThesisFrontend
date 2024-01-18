import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/common.dart';

class PreviewPage extends StatelessWidget {
  final XFile picture;
  final double buttonHeight = 60;
  final Function onClose;
  final Function onSend;

  const PreviewPage(
      {Key? key,
      required this.picture,
      required this.onClose,
      required this.onSend})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
          child: SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.file(File(picture.path),
                      fit: BoxFit.cover,
                      height: 0.9 * size.height,
                      width: size.width),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: buttonHeight,
                          child: ElevatedButton(
                              onPressed: () {
                                onClose();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: Text(
                                  getAppLocalizations(context)!.retakePhoto)),
                        ),
                        Container(
                          height: buttonHeight,
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                  getAppLocalizations(context)!.uploadPhoto)),
                        ),
                      ])
                ],
              ))),
    );
  }

  @override
  void dispose() {
    onClose();
  }
}
