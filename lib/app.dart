import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'data/service.dart';
import 'home/home.dart';

/// The main application widget that provides BLoC and configures MaterialApp.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ToDoBloc(
            toDoDataService: ToDoDataService(),
          ),
        ),
        BlocProvider(
          create: (context) => WeatherBloc(
            weatherDataService: WeatherDataService(),
          ),
        ),
        BlocProvider(
          create: (context) => LanguageCubit(
            languageDataService: LanguageDataService(),
          ),
        ),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData(
              useMaterial3: true,
            ),
            locale: Locale(
              state.selectedLanguage == Language.ukrainian ? 'uk' : 'en',
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            home: _homeScreen(state.loadState),
          );
        },
      ),
    );
  }

  Widget _homeScreen(LoadState loadState) {
    switch (loadState) {
      case LoadState.loaded:
        return const HomeScreen();
      case LoadState.loading:
        return Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
    }
  }
}
