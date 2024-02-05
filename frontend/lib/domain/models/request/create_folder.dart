import 'package:frontend/domain/models/request/create_document.dart';

import '../abstract/serializable_entity.dart';

class CreateFolder extends SerializableEntity{
  final String name;
  final CreateDocument document;

  CreateFolder({required this.name, required this.document});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'document': document.toMap(),
    };
  }
}