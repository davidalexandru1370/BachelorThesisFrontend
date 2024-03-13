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
    print(folder.errors.toString());
    var localization = _localization.getAppLocalizations(context);
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Center(
                child: Column(
              children: [
                Text(
                  "${localization!.folder}: ${folder.name}",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                    folder.isCorrect
                        ? localization.folderIsComplete
                        : localization.folderIsIncomplete,
                    style: TextStyle(
                        color: folder.isCorrect ? Colors.green : Colors.red)),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: folder.errors.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Text(
                            "\u2022 ${localization.folder_error(folder.errors[index])}",
                            style: const TextStyle(
                                fontSize: 13, color: Colors.red)),
                      );
                    })
              ],
            )),
            Container(
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) => Card(
                    child: Row(
                  children: [
                    SizedBox(
                        width: 100,
                        height: 100,
                        child:
                            Image.network(folder.document[index].storageUrl)),
                    Text(
                        " ${localization!.document_type(folder.document[index].documentType.name)}")
                  ],
                )),
                itemCount: folder.document.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _checkIfFolderIsComplete() {
    return false;
  }
}
