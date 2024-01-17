import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/common.dart';

class PreviewPage extends StatelessWidget {
  final XFile picture;
  final double buttonHeight = 60;

  const PreviewPage({Key? key, required this.picture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
          child: SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(File(picture.path),
                      fit: BoxFit.contain,
                      width: 0.9 * size.width,
                      height: 0.8 * size.height),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: buttonHeight,
                          child: ElevatedButton(
                              onPressed: () {},
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
}
