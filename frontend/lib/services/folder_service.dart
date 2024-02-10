import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../domain/models/entities/Folder.dart';
import 'package:http_parser/http_parser.dart';

import '../domain/models/request/create_folder.dart';

class FolderService {
  final String _controller = "folder";
  var logger = Logger();

  Future<Folder> createFolder(CreateFolder folder) async {
    logger.log(Level.info, 'Creating folder: $folder');
    var headers = {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiIyMWVmZWQ3OC04OWRjLTQ4NTEtYWJiMi1lMDBlMTNkNzhiMTIiLCJlbWFpbCI6InN0cmluZyIsIm5iZiI6MTcwNzUxNjc2MiwiZXhwIjoxNzA4MTIxNTYyLCJpYXQiOjE3MDc1MTY3NjIsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAwMC8iLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo1MDAxLyJ9.2tH45RPukSyG7RZzAX8DdzHUfBPwHcALhLjPP21u7Us',
      'Content-Type': 'multipart/form-data'
    };
    var data = FormData.fromMap({
      'name': 'asd',
      // 'Documents[0].File': "a",
      // 'Documents[0].File': await MultipartFile.fromFile(
      //     folder.document[0].image.path,
      //     filename: folder.document[0].image.path),
      // 'Documents[1].File': await MultipartFile.fromFile(
      //     folder.document[0].image.path,
      //     filename: folder.document[0].image.path),
    });

    data.files.addAll([
      MapEntry('Documents[0].File', MultipartFile.fromString("")),
      MapEntry(
        'Documents[0].File',
        await MultipartFile.fromFile(
          folder.document[0].image.path,
          filename: folder.document[0].image.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      ),
      MapEntry(
        'Documents[1].File',
        await MultipartFile.fromFile(
          folder.document[0].image.path,
          filename: folder.document[0].image.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      ),
    ]);

    var dio = Dio();
    var response = await dio.request(
      'http://192.168.1.8:5176/api/folder/',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      print(json.encode(response.data));
    } else {
      print(response.statusMessage);
    }

    return Folder.fromMap(jsonDecode(response.data));
    //return Folder.fromMap(jsonDecode(await response.stream.bytesToString()));
  }
}
