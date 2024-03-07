import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/domain/models/entities/folder.dart';
import 'package:frontend/presentation/l10n/app_l10n.dart';

class ViewFolderScreen extends StatefulWidget {
  final Folder folder;

  const ViewFolderScreen({super.key, required this.folder});

  @override
  State<ViewFolderScreen> createState() =>
      _ViewFolderScreenState(folder: folder);
}

class _ViewFolderScreenState extends State<ViewFolderScreen> {
  final Folder folder;
  var _localization = Localization();

  _ViewFolderScreenState({required this.folder});

  @override
  Widget build(BuildContext context) {
    var localization = _localization.getAppLocalizations(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(folder.name),
          Text(folder.folderType.toString()),
        ],
      ),
    );
  }
}
