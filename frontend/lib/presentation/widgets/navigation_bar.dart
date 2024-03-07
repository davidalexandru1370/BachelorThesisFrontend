import 'package:flutter/material.dart';
import 'package:frontend/domain/exceptions/unauthenticated_exception.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../application/secure_storage/secure_storage.dart';
import '../../application/services/user_service.dart';
import '../../domain/constants/app_constants.dart';
import '../l10n/app_l10n.dart';
import '../providers/authentication_state.dart';
import '../screens/main_screen.dart';
import '../screens/new_folder_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/register_screen.dart';

class ApplicationNavigationBar extends StatefulWidget {
  const ApplicationNavigationBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ApplicationNavigationBarState();
}

class _ApplicationNavigationBarState extends State<ApplicationNavigationBar> {
  int _currentPageIndex = 0;
  final _localization = Localization();
  final SecureStorage _storage = SecureStorage();
  bool _loading = true;
  final Logger _logger = Logger();

  @override
  void initState() {
    _getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    var localization = _localization.getAppLocalizations(context);

    if (_loading == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    try {
      return Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) async {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateNewFolderScreen()),
              );
            } else {
              setState(() {
                _currentPageIndex = index;
              });
            }
          },
          indicatorColor: Colors.amber[800],
          selectedIndex: _currentPageIndex,
          destinations: <Widget>[
            NavigationDestination(
              icon: const Icon(Icons.home),
              selectedIcon: const Icon(Icons.home),
              label: localization!.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.folder),
              selectedIcon: const Icon(Icons.folder),
              label: localization!.submit,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: localization.profile,
            ),
          ],
        ),
        body: <Widget>[
          const MainPage(),
          const Placeholder(),
          ProfileScreen()
        ][_currentPageIndex],
      );
    } on UnauthenticatedException catch (e) {
      _logger.log(Level.error, e);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()));
      return const Scaffold();
    }
  }

  Future<void> _getUserProfile() async {
    await Future.delayed(const Duration(seconds: 0));

    final token = await _storage.read(AppConstants.ACCESS_TOKEN);
    final authenticationProvider = context.read<AuthenticationProvider>();
    try {
      var userProfile = await UserService.getUserProfile(token!);
      authenticationProvider.setUserProfile(userProfile);
      setState(() {
        _loading = false;
      });
    } on Exception catch (e) {
      _logger.log(Level.error, e);
      await _storage.delete(AppConstants.ACCESS_TOKEN);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()));
    }
  }
}
