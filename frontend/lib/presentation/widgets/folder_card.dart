import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/domain/models/entities/folder.dart';

import '../l10n/app_l10n.dart';

class FolderCard extends StatelessWidget {
  final Folder _folder;
  final Function _onDelete;
  final Function _onClick;
  final _localization = Localization();

  FolderCard(
      {Key? key,
      required Folder folder,
      required Function onDelete,
      required Function onClick})
      : _onClick = onClick,
        _onDelete = onDelete,
        _folder = folder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var localization = _localization.getAppLocalizations(context);
    return GestureDetector(
      onTap: () {
        _onClick();
      },
      child: Card(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Visibility(
            visible: _folder.document.isNotEmpty,
            child: SizedBox(
                width: 100,
                height: 100,
                child: _folder.document.isNotEmpty
                    ? Image.network(_folder.document[0].storageUrl)
                    : const SizedBox())),
        Row(
          children: [
            Text(
                localization!.folder_type(_folder.folderType.index.toString())),
            GestureDetector(
              onTap: () async {
                await _onDelete();
              },
              child: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ])),
    );
  }
}
