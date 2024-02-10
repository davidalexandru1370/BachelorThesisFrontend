import 'package:frontend/domain/models/request/create_document.dart';

class CreateFolder {
  final String name;
  final List<CreateDocument> document;

  CreateFolder({required this.name, required this.document});

  @override
  String toString() {
    return 'CreateFolder{name: $name, document: $document}';
  }
}