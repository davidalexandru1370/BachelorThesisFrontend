import 'package:flutter/material.dart';
import 'package:frontend/application/secure_storage/secure_storage.dart';
import 'package:frontend/domain/constants/app_constants.dart';
import 'package:frontend/presentation/providers/authentication_state.dart';
import 'package:frontend/presentation/screens/register_screen.dart';
import 'package:frontend/presentation/widgets/navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  ensureCameraWorks();

  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  final _storage = SecureStorage();
  bool _waiting = true;
  Widget _nextScreen = const RegisterScreen();

  @override
  void initState() {
    _checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    if (_waiting == true) {
      return const Scaffold(
        body: SizedBox(
          height: double.infinity,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircularProgressIndicator(),
          ]),
        ),
      );
    }

    return Scaffold(
        body: MultiProvider(
            providers: [
          ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
          ChangeNotifierProvider(create: (context) => LocaleModel())
        ],
            child: Consumer<LocaleModel>(
                builder: (context, localeModel, child) => MaterialApp(
                    title: 'SDIA',
                    theme: ThemeData(
                      colorScheme: ColorScheme.fromSeed(
                          seedColor: const Color.fromARGB(255, 119, 119, 119)),
                      useMaterial3: true,
                    ),
                    supportedLocales: AppLocalizations.supportedLocales,
                    locale: localeModel.locale,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    home: _nextScreen))));
  }

  Future<void> _checkIfLoggedIn() async {
    if ((await _storage.contains(AppConstants.ACCESS_TOKEN)) == false) {
      setState(() {
        _waiting = false;
      });
      return;
    }

    setState(() {
      _waiting = false;
      _nextScreen = const ApplicationNavigationBar();
    });
  }
}

class LocaleModel extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale ?? const Locale("ro");

  void setLocale(Locale value) {
    _locale = value;
    notifyListeners();
  }
}

void ensureCameraWorks() {
  WidgetsFlutterBinding.ensureInitialized();
}
