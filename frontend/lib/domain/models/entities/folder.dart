import 'package:frontend/domain/models/abstract/serializable_entity.dart';

import '../../enums/folder_type.dart';
import 'package:uuid/uuid.dart';

import 'document.dart';

class Folder extends SerializableEntity {
  Uuid id;
  String name;
  FolderType folderType;
  List<Document> document;

  Folder(
      {required this.id,
      required this.name,
      required this.folderType,
      this.document = const []});

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'folderType': folderType,
      'document': document,
    };
  }

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'],
      name: map['name'],
      folderType: map['folderType'],
      document: map['document'],
    );
  }
}
