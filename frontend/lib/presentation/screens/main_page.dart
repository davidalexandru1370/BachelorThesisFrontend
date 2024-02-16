import 'package:flutter/material.dart';
import 'package:frontend/application/services/document_service.dart';
import 'package:frontend/application/services/folder_service.dart';
import 'package:frontend/domain/constants/app_constants.dart';
import 'package:frontend/domain/exceptions/application_exception.dart';
import 'package:frontend/domain/exceptions/unauthenticated_exception.dart';
import 'package:frontend/domain/models/entities/document.dart';
import 'package:frontend/domain/models/entities/folder.dart';
import 'package:frontend/presentation/extensions/exception_extensions.dart';
import 'package:frontend/presentation/l10n/app_l10n.dart';
import 'package:frontend/presentation/widgets/notifications/toast_notification.dart';

import '../../application/secure_storage/secure_storage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final SecureStorage _storage = SecureStorage();
  final FolderService _folderService = FolderService();
  final _localization = Localization();
  List<Folder> _folders = <Folder>[];
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _getAllDocuments();
  }

  @override
  Widget build(BuildContext context) {
    var localization = _localization.getAppLocalizations(context);
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {},
            separatorBuilder: (context, index) => const Divider(),
            itemCount: _folders.length),
      ),
    );
  }

  Future<void> _getAllDocuments() async {
    await Future.delayed(const Duration(seconds: 0));
    var token = await _storage.readOrThrow(
        AppConstants.TOKEN, UnauthenticatedException(''));
    try {
      var folders = await _folderService.getAllFolders(token!);
      setState(() {
        _folders = folders;
      });
    } on ApplicationException catch (e) {
      var message = _localization
          .getAppLocalizations(context)!
          .backend_error(e.getMessage);
      ToastNotification.showError(context, message);
      setState(() {
        _hasError = true;
      });
    }
  }
}
