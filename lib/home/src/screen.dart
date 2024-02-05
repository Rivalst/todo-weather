import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:wat_do/common/value.dart';
import 'package:wat_do/home/home.dart';

import 'widgets/weather.dart';
import 'widgets/todo.dart';

/// Represents the home screen of the application with tabs for ToDo and Weather sections.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedLanguage =
        context.read<LanguageCubit>().state.selectedLanguage;

    final language = switch (selectedLanguage) {
      Language.english => 'en',
      Language.ukrainian => 'uk',
    };

    return DefaultTabController(
      length: kTabCount,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wat Do'),
          actions: [
            TextButton(
              onPressed: () => _changeLanguage(
                context,
                selectedLanguage,
              ),
              child: Text(language),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: AppLocalizations.of(context)!.todo,
              ),
              Tab(
                text: AppLocalizations.of(context)!.weather,
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ToDoWidget(),
            WeatherWidget(),
          ],
        ),
      ),
    );
  }

  void _changeLanguage(
    BuildContext context,
    Language language,
  ) {
    switch (language) {
      case Language.english:
        context.read<LanguageCubit>().changeLanguage(Language.ukrainian);
      case Language.ukrainian:
        context.read<LanguageCubit>().changeLanguage(Language.english);
    }
  }
}
