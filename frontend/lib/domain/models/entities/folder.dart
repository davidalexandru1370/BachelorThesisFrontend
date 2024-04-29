import 'package:frontend/domain/models/abstract/serializable_entity.dart';

import '../../enums/folder_type.dart';
import 'package:uuid/uuid.dart';

import 'document.dart';

class Folder extends SerializableEntity {
  String id;
  String name;
  FolderType folderType;
  bool isCorrect;
  List<String> errors;
  List<Document> document;

  Folder(
      {required this.id,
      required this.name,
      required this.folderType,
      required this.isCorrect,
      required this.errors,
      this.document = const []});

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'folderType': folderType.index,
      'document': document,
    };
  }

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'],
      name: map['name'],
      folderType: FolderType.values.firstWhere((e) => e.index == map['type']),
      isCorrect: map['isCorrect'],
      errors:
          (map['errors'] as List<dynamic>).map((e) => e.toString()).toList(),
      document: (map['documents'] as List<dynamic>)
          .map((e) => Document.fromMap(e))
          .toList(),
    );
  }
}
