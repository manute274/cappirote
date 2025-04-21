import 'package:CAPPirote/config/router/app_router.dart';
import 'package:CAPPirote/config/theme/app_theme.dart';
import 'package:CAPPirote/presentation/providers/auth_provider.dart';
import 'package:CAPPirote/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: "CAPPirote",
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('es')
            ],
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lighttheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: appRouter,
            //home: const HomeScreen(),
          );
        },
      ),
    );
  }
}

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}
