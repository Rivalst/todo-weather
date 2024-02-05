part of 'bloc.dart';

enum LoadState {
  loading,
  loaded,
}
/// Represents the state of the to-do items in the application.
/// Includes lists of ToDo items, load state, and filter settings.
final class ToDoState extends Equatable {
  final List<ToDoModel> listOfToDoSelected;
  final List<ToDoModel> allToDo;
  final LoadState loadState;
  final FilterSettings filterSettings;

  const ToDoState({
    required this.listOfToDoSelected,
    required this.loadState,
    required this.filterSettings,
    required this.allToDo,
  });

  ToDoState copyWith({
    required LoadState loadState,
    FilterSettings? filterSettings,
    List<ToDoModel>? listOfToDoSelected,
    List<ToDoModel>? allToDo,
  }) {
    return ToDoState(
      listOfToDoSelected: listOfToDoSelected ?? this.listOfToDoSelected,
      loadState: loadState,
      filterSettings: filterSettings ?? this.filterSettings,
      allToDo: allToDo ?? this.allToDo,
    );
  }

  @override
  List<Object?> get props => [listOfToDoSelected, loadState];
}
