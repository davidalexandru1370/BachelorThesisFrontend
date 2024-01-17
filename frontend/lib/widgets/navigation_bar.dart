import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/camera_screen.dart';
import 'package:frontend/screens/main_page.dart';

class ApplicationNavigationBar extends StatefulWidget {
  const ApplicationNavigationBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ApplicationNavigationBarState();
}

class _ApplicationNavigationBarState extends State<ApplicationNavigationBar> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CameraScreen()),
            );
          } else {
            setState(() {
              _currentPageIndex = index;
            });
          }
        },
        indicatorColor: Colors.amber[800],
        selectedIndex: _currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera),
            selectedIcon: Icon(Icons.camera),
            label: 'Camera',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        MainPage(),
      ][_currentPageIndex],
    );
  }
}
