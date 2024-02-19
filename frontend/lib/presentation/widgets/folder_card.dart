import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/domain/models/entities/folder.dart';

class FolderCard extends StatelessWidget {
  final Folder _folder;

  const FolderCard({Key? key, required Folder folder})
      : _folder = folder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Visibility(
          visible: _folder.document.isNotEmpty,
          child: SizedBox(
              width: 100,
              height: 100,
              child: Image.network(_folder.document[0].storageUrl))),
      Column(
        children: [
          Text(_folder.name),
        ],
      ),
    ]));
  }
}
