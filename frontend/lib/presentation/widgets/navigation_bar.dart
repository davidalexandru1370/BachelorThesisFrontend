import 'package:flutter/material.dart';

import '../l10n/app_l10n.dart';
import '../screens/main_page.dart';
import '../screens/new_folder_screen.dart';

class ApplicationNavigationBar extends StatefulWidget {
  const ApplicationNavigationBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ApplicationNavigationBarState();
}

class _ApplicationNavigationBarState extends State<ApplicationNavigationBar> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var localization = getAppLocalizations(context);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
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
        MainPage(),
      ][_currentPageIndex],
    );
  }
}
