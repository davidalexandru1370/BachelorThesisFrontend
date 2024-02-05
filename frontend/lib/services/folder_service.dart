import 'dart:convert';

import '../domain/constants/api_constants.dart';
import '../domain/models/entities/Folder.dart';
import 'package:http/http.dart' as http;

import '../domain/models/request/create_folder.dart';

class FolderService {
  final String _controller = "folder";

  Future<Folder> createFolder(CreateFolder folder) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.BASE_URL}/$_controller'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(folder),
    );

    return Folder.fromMap(jsonDecode(response.body));

  }
}
