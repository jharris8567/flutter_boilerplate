import 'package:boilerplate/features/application/bloc/application_bloc.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'router/app_router.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ApplicationBloc _bloc;
  late String _locale;
  late bool _isDarkMode;

  @override
  void initState() {
    _locale = 'en';
    _bloc = ApplicationBloc();
    _bloc.add(const ApplicationLoaded());
    _isDarkMode = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ApplicationBloc>.value(
          value: _bloc,
        ),
      ],
      child: BlocListener<ApplicationBloc, ApplicationState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state.status == UIStatus.loadSuccess) {
            if (_locale != state.locale) {
              setState(() {
                _locale = state.locale;
              });
            }

            if (_isDarkMode != state.isDarkMode) {
              setState(() {
                _isDarkMode = state.isDarkMode;
              });
            }
          }
        },
        child: MaterialApp.router(
          // Localization
          localizationsDelegates: const [
            AppLocalizationDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('vi'),
          ],
          locale: Locale(_locale),
          themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.blue[600],
            brightness: Brightness.light,
            backgroundColor: Colors.grey[100],
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.blue[300],
            brightness: Brightness.dark,
            backgroundColor: Colors.grey[900],
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          routeInformationProvider: AppRouter.router.routeInformationProvider,
          routeInformationParser: AppRouter.router.routeInformationParser,
          routerDelegate: AppRouter.router.routerDelegate,
          title: "BoilerPlate",
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}