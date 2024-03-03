import 'package:flutter/material.dart';
import 'package:frontend/application/services/folder_service.dart';
import 'package:frontend/domain/constants/app_constants.dart';
import 'package:frontend/domain/exceptions/application_exception.dart';
import 'package:frontend/domain/exceptions/unauthenticated_exception.dart';
import 'package:frontend/domain/models/entities/folder.dart';
import 'package:frontend/presentation/extensions/exception_extensions.dart';
import 'package:frontend/presentation/l10n/app_l10n.dart';
import 'package:frontend/presentation/widgets/folder_card.dart';
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
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _getAllDocuments();
  }

  @override
  Widget build(BuildContext context) {
    var localization = _localization.getAppLocalizations(context);

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localization!.error),
            TextButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
                await _getAllDocuments();
              },
              child: Text(localization.tryAgain),
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: _isLoading == true
            ? SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    Text(localization!.loading)
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _isLoading = true;
                    _hasError = false;
                  });
                  await _getAllDocuments();
                },
                child: Center(
                  child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: FolderCard(folder: _folders[index]));
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: _folders.length),
                ),
              ),
      ),
    );
  }

  Future<void> _getAllDocuments() async {
    await Future.delayed(const Duration(seconds: 0));
    var token = await _storage.readOrThrow(
        AppConstants.ACCESS_TOKEN, UnauthenticatedException());
    try {
      var folders = await _folderService.getAllFolders(token!);
      setState(() {
        _hasError = false;
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
