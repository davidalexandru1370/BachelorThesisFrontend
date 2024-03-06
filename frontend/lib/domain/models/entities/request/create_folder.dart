import 'package:frontend/domain/models/abstract/serializable_entity.dart';

import 'create_document.dart';

class CreateFolder extends SerializableEntity{
  final String name;
  final List<CreateDocument> document;

  CreateFolder({required this.name, required this.document});

  @override
  String toString() {
    return 'CreateFolder{name: $name, document: $document}';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}