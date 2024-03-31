import 'package:frontend/domain/enums/folder_type.dart';

import 'create_document.dart';

class CreateFolder {
  final String name;
  final FolderType folderType;
  final List<CreateDocument> document;

  CreateFolder(
      {required this.name, required this.folderType, required this.document});

  @override
  String toString() {
    return 'CreateFolder{name: $name, document: $document}';
  }
}
