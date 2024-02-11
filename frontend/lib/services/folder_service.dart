import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/domain/constants/api_constants.dart';
import 'package:frontend/domain/constants/app_constants.dart';
import 'package:frontend/domain/exceptions/unauthenticated_exception.dart';
import 'package:logger/logger.dart';
import '../domain/models/entities/Folder.dart';

import '../domain/models/request/create_folder.dart';

class FolderService {
  final String _controller = "folder";
  var logger = Logger();
  final _secureStorage = const FlutterSecureStorage();

  FolderService() {
    if (_secureStorage.containsKey(key: AppConstants.TOKEN) == false) {
      throw UnauthenticatedException('Token not found');
    }
  }

  Future<Folder> createFolder(CreateFolder folder) async {
    logger.log(Level.info, 'Creating folder: $folder');
    var headers = {
      'Authorization': 'Bearer ${_secureStorage.read(key: AppConstants.TOKEN)}',
      'Content-Type': 'multipart/form-data'
    };

    var data = FormData.fromMap({
      'name': '${folder.name}',
    });

    data.files.addAll([
      MapEntry('Documents[0].File', MultipartFile.fromString("")),
    ]);

    for(var i = 0; i < folder.document.length; i++){
      data.files.addAll([
        MapEntry('Documents[$i].File', await MultipartFile.fromFile(folder.document[i].image.path)),
      ]);
    }

    var dio = Dio();
    var response = await dio.request(
      '${ApiConstants.BASE_URL}/${_controller}/',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      logger.log(Level.info, 'Folder created successfully');
    } else {
      logger.log(Level.error, response.statusMessage);
    }

    return Folder.fromMap(jsonDecode(response.data));

  }
}
