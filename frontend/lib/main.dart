import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/register_screen.dart';
import 'package:frontend/presentation/widgets/navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  ensureCameraWorks();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LocaleModel(),
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
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                home: const RegisterScreen())));
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
