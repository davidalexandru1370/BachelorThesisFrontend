import 'dart:convert';

import 'package:frontend/domain/constants/api_constants.dart';

import '../domain/models/entities/document.dart';
import 'package:http/http.dart' as http;

import '../domain/models/response/error_details.dart';

class DocumentService {
  final String _controller = "document";

  DocumentService() {}

  Future<List<Document>> getAllDocuments() async {
    var response = await http.get(
      Uri.parse("${ApiConstants.BASE_URL}/${_controller}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': ''
      },
    );

    if (response.statusCode == 200) {
      var body = response.body;
      var jsonList = jsonDecode(body) as List;

      var assignments =
          jsonList.map((json) => Document.fromMap(json)).toList();

      return assignments;
    } else {
      var body = response.body;
      var errorDetails = ErrorDetails.fromJson(jsonDecode(body));

      throw Exception(errorDetails.message);
    }
  }

}
