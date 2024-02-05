part of 'cubit.dart';

enum Language { english, ukrainian }

/// Represents the state of language selection, including the selected language and the loading state.
class LanguageState extends Equatable {
  final Language selectedLanguage;
  final LoadState loadState;

  const LanguageState(
    this.selectedLanguage,
    this.loadState,
  );

  @override
  List<Object?> get props => [
        selectedLanguage,
        loadState,
      ];
}
