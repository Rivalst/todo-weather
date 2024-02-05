import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:wat_do/data/model.dart';
import 'package:wat_do/data/service.dart';

part 'event.dart';
part 'state.dart';

enum FilterSettings { all, done, notDone, category }

/// BLoC class responsible for managing the state
/// of to-do items in the application. It handles events such as loading, adding,
/// updating, deleting, and changing the done status of to-do items or filtering.
class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  final ToDoDataService toDoDataService;

  ToDoBloc({
    required this.toDoDataService,
  }) : super(
          const ToDoState(
            listOfToDoSelected: [],
            allToDo: [],
            loadState: LoadState.loading,
            filterSettings: FilterSettings.all,
          ),
        ) {
    on<ListOfToDoLoaded>(_loadAllToDo);
    on<ToDoAdded>(_setToDo);
    on<ToDoDeleted>(_deleteToDo);
    on<ToDoUpdated>(_updateToDo);
    on<ToDoDoneStatusChanged>(_changeDoneStatus);
    on<FilterSettingsChanged>(_changeFilterSettings);
  }

  // Loaded ToDo items from local database
  Future<void> _loadAllToDo(
    ListOfToDoLoaded event,
    Emitter<ToDoState> emit,
  ) async {
    final listOfToDo = await toDoDataService.getData();

    emit(
      state.copyWith(
        listOfToDoSelected: listOfToDo,
        allToDo: listOfToDo,
        loadState: LoadState.loaded,
      ),
    );
  }

  // Set new ToDo item to local database
  Future<void> _setToDo(
    ToDoAdded event,
    Emitter<ToDoState> emit,
  ) async {
    await toDoDataService.setData(model: event.model);

    final listOfToDo =
        await toDoDataService.getData(settings: state.filterSettings);

    final allToDo = await toDoDataService.getData();

    emit(
      state.copyWith(
        listOfToDoSelected: listOfToDo,
        allToDo: allToDo,
        loadState: LoadState.loaded,
      ),
    );
  }

  // Update ToDo item
  Future<void> _updateToDo(
    ToDoUpdated event,
    Emitter<ToDoState> emit,
  ) async {
    await toDoDataService.updateData(
      index: event.index,
      model: event.model,
    );

    final listOfToDo =
        await toDoDataService.getData(settings: state.filterSettings);

    final allToDo = await toDoDataService.getData();

    emit(
      state.copyWith(
        listOfToDoSelected: listOfToDo,
        allToDo: allToDo,
        loadState: LoadState.loaded,
      ),
    );
  }

  // Delete ToDo item from local database
  Future<void> _deleteToDo(
    ToDoDeleted event,
    Emitter<ToDoState> emit,
  ) async {
    await toDoDataService.deleteData(index: event.index);

    final listOfToDo =
        await toDoDataService.getData(settings: state.filterSettings);

    final allToDo = await toDoDataService.getData();

    emit(
      state.copyWith(
        listOfToDoSelected: listOfToDo,
        allToDo: allToDo,
        loadState: LoadState.loaded,
      ),
    );
  }

  // Change ToDo done status
  Future<void> _changeDoneStatus(
    ToDoDoneStatusChanged event,
    Emitter<ToDoState> emit,
  ) async {
    final changedModel = event.model.copyWith(isDone: !event.model.isDone);
    await toDoDataService.updateData(
      model: changedModel,
      index: event.index,
    );

    final listOfToDo =
        await toDoDataService.getData(settings: state.filterSettings);

    final allToDo = await toDoDataService.getData();

    emit(
      state.copyWith(
        listOfToDoSelected: listOfToDo,
        allToDo: allToDo,
        loadState: LoadState.loaded,
      ),
    );
  }

  // Change filter settings that allow see only selected ToDo by filter
  Future<void> _changeFilterSettings(
    FilterSettingsChanged event,
    Emitter<ToDoState> emit,
  ) async {
    final listOfToDo = await toDoDataService.getData(
      settings: event.settings,
      category: event.category,
    );

    final allToDo = await toDoDataService.getData();

    emit(
      state.copyWith(
        listOfToDoSelected: listOfToDo,
        allToDo: allToDo,
        loadState: LoadState.loaded,
        filterSettings: event.settings,
      ),
    );
  }
}
