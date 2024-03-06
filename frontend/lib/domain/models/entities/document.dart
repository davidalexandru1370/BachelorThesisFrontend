import '../../enums/document_type.dart';

class Document {
  final String id;
  final String storageUrl;
  final DocumentType documentType;

  Document(
      {required this.id, required this.storageUrl, required this.documentType});

  factory Document.fromMap(Map<String, dynamic> map) {
    print(map.toString());
    return Document(
      id: map['id'],
      storageUrl: map['storageUrl'],
      documentType:
          DocumentType.values.firstWhere((e) => e.index == map['documentType']),
    );
  }
}
