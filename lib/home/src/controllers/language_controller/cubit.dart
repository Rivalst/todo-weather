import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wat_do/data/service.dart';
import 'package:wat_do/home/home.dart';

part 'state.dart';

/// Cubit responsible for managing the language state, including loading language data.
/// It allows changing the language and tracks the loading state.
class LanguageCubit extends Cubit<LanguageState> {
  final LanguageDataService languageDataService;

  LanguageCubit({required this.languageDataService})
      : super(
          const LanguageState(
            Language.english,
            LoadState.loading,
          ),
        ) {
    loadLanguage();
  }

  void changeLanguage(Language newLanguage) {
    emit(
      LanguageState(
        newLanguage,
        LoadState.loaded,
      ),
    );
    languageDataService.setData(newLanguage);
  }

  void loadLanguage() async {
    final language = await languageDataService.getData();
    switch (language) {
      case 'uk':
        emit(
          const LanguageState(
            Language.ukrainian,
            LoadState.loaded,
          ),
        );
      case 'en':
        emit(
          const LanguageState(
            Language.english,
            LoadState.loaded,
          ),
        );
      default:
        emit(
          const LanguageState(
            Language.english,
            LoadState.loaded,
          ),
        );
    }
  }
}
