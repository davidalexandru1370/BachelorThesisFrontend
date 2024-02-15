import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/register_screen.dart';
import 'package:provider/provider.dart';

import '../../application/secure_storage/secure_storage.dart';
import '../../application/services/user_service.dart';
import '../../domain/constants/app_constants.dart';
import '../state/authentication_state.dart';
import '../widgets/navigation_bar.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final SecureStorage _storage = SecureStorage();
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const ApplicationNavigationBar(),
    );
  }

  Future<void> _getUserProfile() async {
    final token = await _storage.read(AppConstants.TOKEN);
    try {
      var userProfile = await UserService.getUserProfile(token!);
      context.read<AuthenticationState>().setUserProfile(userProfile);
      setState(() {
        _loading = false;
      });
    } on Exception catch (_) {
      await _storage.delete(AppConstants.TOKEN);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()));
    }
  }
}
