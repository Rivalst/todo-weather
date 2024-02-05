part of 'bloc.dart';

sealed class ToDoEvent extends Equatable {}

/// Event signaling that the list of to-do items has been loaded.
final class ListOfToDoLoaded extends ToDoEvent {
  @override
  List<Object?> get props => [];
}

/// Event indicating the addition of a new to-do item.
final class ToDoAdded extends ToDoEvent {
  final ToDoModel model;

  ToDoAdded({required this.model});
  @override
  List<Object?> get props => [model];
}

/// Event representing an update to an existing to-do item.
final class ToDoUpdated extends ToDoEvent {
  final int index;
  final ToDoModel model;

  ToDoUpdated({
    required this.index,
    required this.model,
  });

  @override
  List<Object?> get props => [index, model];
}

/// Event indicating the deletion of a to-do item.
final class ToDoDeleted extends ToDoEvent {
  final int index;

  ToDoDeleted({required this.index});
  @override
  List<Object?> get props => [index];
}

/// Event marking a change in the done status of a to-do item.
final class ToDoDoneStatusChanged extends ToDoEvent {
  final int index;
  final ToDoModel model;

  ToDoDoneStatusChanged({
    required this.index,
    required this.model,
  });

  @override
  List<Object?> get props => [index, model];
}

/// Event representing a change in filter settings for to-do items.
final class FilterSettingsChanged extends ToDoEvent {
  final FilterSettings settings;
  final String? category;

  FilterSettingsChanged({
    required this.settings,
    this.category,
  });

  @override
  List<Object?> get props => [settings, category];
}
