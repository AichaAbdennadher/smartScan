import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_scan/l10n/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/settings_provider.dart';
import 'providers/history_provider.dart';
import 'providers/scan_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/navigation_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //prépare Flutter avant toute opération asynchrone
  await initializeDateFormatting('fr', null); //initialise les formats de date pour le français
  await initializeDateFormatting('en', null); 
  await initializeDateFormatting('ar', null); 
  runApp(
    //pour gérer l’état global de ton app.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()), //permet d'acceder au settings depuis n'importe ou
        ChangeNotifierProvider(create: (_) => HistoryProvider()), //permet d'acceder au history depuis n'importe ou
        ChangeNotifierProvider(create: (_) => ScanProvider()), //permet d'acceder au scan depuis n'importe ou
      ],
      child: const SmartScanApp(),
    ),
  );
}

class SmartScanApp extends StatelessWidget {
  const SmartScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>(); //permet d'ecouter les chnagement theme /langue

    return MaterialApp(
      title: 'SmartScan Assistant',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode, //dyanmique 
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      locale: Locale(settings.language),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
        Locale('ar'),
      ],
      initialRoute: '/onboarding',
      routes: {
        '/': (context) => const NavigationShell(), // 1 er fois  
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}
