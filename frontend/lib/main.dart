import 'package:flutter/material.dart';
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
                localeListResolutionCallback: (allLocales, supportedLocales) {
                  final locale = allLocales?.first.languageCode;
                  if (locale != 'ro') {
                    return Locale(locale!);
                  }
                  return const Locale("ro");
                },
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                home: ApplicationNavigationBar())));
  }
}

class LocaleModel extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(Locale value) {
    _locale = value;
    notifyListeners();
  }
}

void ensureCameraWorks() {
  WidgetsFlutterBinding.ensureInitialized();
}
