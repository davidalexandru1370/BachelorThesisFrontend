import '../../enums/document_type.dart';

class Document {
  final String id;
  final DocumentType documentType;
  final DateTime CreatedAt;

  Document(
      {required this.id, required this.documentType, required this.CreatedAt});

  static Document fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      documentType: json['documentType'],
      CreatedAt: json['CreatedAt'],
    );
  }
}
