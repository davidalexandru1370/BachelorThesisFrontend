import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/application/secure_storage/secure_storage.dart';
import 'package:frontend/domain/constants/api_constants.dart';
import 'package:frontend/domain/constants/app_constants.dart';
import 'package:frontend/domain/exceptions/application_exception.dart';
import 'package:frontend/domain/exceptions/unauthenticated_exception.dart';
import 'package:frontend/domain/models/entities/error_details.dart';
import 'package:frontend/domain/models/entities/request/create_folder.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../domain/models/entities/folder.dart';

class FolderService {
  final String _controller = "folder";
  var _logger = Logger();
  final _secureStorage = SecureStorage();

  FolderService() {
    if (_secureStorage.contains(AppConstants.ACCESS_TOKEN) == false) {
      throw UnauthenticatedException(message: 'Unauthorized');
    }
  }

  Future<Folder> createFolder(CreateFolder folder) async {
    _logger.log(Level.info, 'Creating folder: $folder');
    var headers = {
      'Authorization':
          'Bearer ${await _secureStorage.read(AppConstants.ACCESS_TOKEN)}',
      'Content-Type': 'multipart/form-data'
    };

    var data = FormData.fromMap({
      'name': folder.name,
      'folderType': folder.folderType.index,
    });

    data.files.addAll([
      MapEntry('Documents[0].File', MultipartFile.fromString("")),
    ]);

    for (var i = 0; i < folder.document.length; i++) {
      data.files.addAll([
        MapEntry('Documents[$i].File',
            await MultipartFile.fromFile(folder.document[i].image.path)),
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
      _logger.log(Level.info, 'Folder created successfully');
    } else {
      _logger.log(Level.error, 'Error creating folder');
      if (response.statusCode == 401) {
        throw UnauthenticatedException(message: 'Unauthorized');
      } else {
        var errorDetails = ErrorDetails.fromMap(jsonDecode(response.data));
        _logger.log(Level.error, errorDetails);
        throw ApplicationException(errorDetails.message);
      }
    }

    return Folder.fromMap(response.data);
  }

  Future<List<Folder>> getAllFolders(String token) async {
    _logger.log(Level.info, 'Getting all folders for current user');
    var response = await http.get(Uri.parse('${ApiConstants.BASE_URL}/folder'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      _logger.log(Level.info, 'Got all folders successfully');
      return (jsonDecode(response.body) as List)
          .map((e) => Folder.fromMap(e))
          .toList();
    } else {
      _logger.log(Level.error, "Error getting all folders");
      _handleError(response);
      throw UnauthenticatedException();
    }
  }

  Future<void> deleteFolder(String folderId) async {
    _logger.log(Level.info, 'Deleting folder by id');
    var token = await _secureStorage.readOrThrow(
        AppConstants.ACCESS_TOKEN, UnauthenticatedException());

    var response = await http.delete(
        Uri.parse('${ApiConstants.BASE_URL}/folder/$folderId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      _logger.log(Level.info, "Deleted folder successfully");
    } else {
      _logger.log(Level.error, "Error deleting folder by id");
      _handleError(response);
    }
  }

  void _handleError(http.Response response) {
    if (response.statusCode == 401) {
      throw UnauthenticatedException();
    }

    var errorDetails = ErrorDetails.fromMap(jsonDecode(response.body));
    _logger.log(Level.error, errorDetails);
    throw ApplicationException(errorDetails.message);
  }
}
