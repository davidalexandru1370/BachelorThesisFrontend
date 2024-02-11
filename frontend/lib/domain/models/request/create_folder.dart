import 'package:frontend/domain/models/request/create_document.dart';

import '../abstract/serializable_entity.dart';

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