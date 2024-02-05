import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:wat_do/common/extension.dart';
import 'package:wat_do/common/value.dart';
import 'package:wat_do/data/model.dart';
import 'package:wat_do/home/home.dart';

import 'full_todo_screen.dart';
import 'new_todo_screen.dart';

///
/// Widget representing the ToDo section in the home screen,
/// allowing users to view and interact with their to-do items.
class ToDoWidget extends StatelessWidget {
  const ToDoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // loading ToDo list
    context.read<ToDoBloc>().add(ListOfToDoLoaded());
    return BlocBuilder<ToDoBloc, ToDoState>(builder: (context, state) {
      return Stack(
        children: [
          _mainScreen(context, state),
          // Opened screen for creating new ToDo
          Positioned(
            right: kToDoButtonsRightMarginValue,
            bottom: kToDoAddButtonMarginValue,
            child: IconButton(
              onPressed: () => _showNewToDoScreen(
                context,
                state,
              ),
              icon: const Icon(
                Icons.add,
              ),
            ),
          ),
          // Opened ToDo filter settings dialog
          if (state.allToDo.isNotEmpty)
            Positioned(
              right: kToDoButtonsRightMarginValue,
              bottom: kToDoFilterButtonMarginValue,
              child: IconButton(
                onPressed: () => _showFilter(
                  context,
                  state,
                ),
                icon: const Icon(
                  Icons.menu,
                ),
              ),
            )
        ],
      );
    });
  }

  Widget _mainScreen(
    BuildContext context,
    ToDoState state,
  ) {
    switch (state.loadState) {
      case LoadState.loading:
        // Screen for waiting loading
        return _buildLoading(context);
      case LoadState.loaded:
        // Screen for display ToDo list
        return _buildLoaded(context, state);
    }
  }

  /// Screen for waiting loading
  Widget _buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// Screen for display ToDo list
  Widget _buildLoaded(
    BuildContext context,
    ToDoState state,
  ) {
    final itemCount = state.listOfToDoSelected.length;
    if (itemCount == 0) {
      return const Center(
        child: Text(
          'Create your first ToDo',
          style: TextStyle(color: Colors.black),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          final todo = state.listOfToDoSelected[index];
          return Padding(
            padding: const EdgeInsets.all(kSmallPadding),
            child: SizedBox(
              height: kButtonHight,
              child: FilledButton(
                onPressed: () => _showFullToDoScreen(
                  context,
                  todo,
                  state,
                  index,
                ),
                style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll<Color>(
                      kButtonBackgroundColor),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kButtonBorderRadius),
                      side: BorderSide(
                        color: todo.isDone
                            ? Colors.transparent
                            : kButtonBorderColor,
                        width: kBorderSideWidth,
                      ),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: kSmallPadding),
                      child: Text(
                        todo.name,
                        style: const TextStyle(
                            fontSize: kTitleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    // Button for change done status
                    IconButton(
                      onPressed: () => context.read<ToDoBloc>().add(
                            ToDoDoneStatusChanged(
                              index: index,
                              model: todo,
                            ),
                          ),
                      icon: Icon(
                        todo.isDone
                            ? Icons.check_circle_outline
                            : Icons.circle_outlined,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  /// Opened screen for creating new ToDo
  Future<void> _showNewToDoScreen(
    BuildContext context,
    ToDoState state,
  ) async {
    final allToDo = state.allToDo;

    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return Material(
            child: NewToDoScreen(
              allToDo: allToDo,
            ),
          );
        },
      ),
    ).then(
      (value) {
        if (value is ToDoModel) {
          context.read<ToDoBloc>().add(
                ToDoAdded(
                  model: value,
                ),
              );
        }
      },
    );
  }

  /// Show all info about ToDo
  /// Also can change ToDo fields in this screen
  Future<void> _showFullToDoScreen(
    BuildContext context,
    ToDoModel model,
    ToDoState state,
    int index,
  ) async {
    final allToDo = state.allToDo;

    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return Material(
            child: FullToDoScreen(
              model: model,
              allToDo: allToDo,
            ),
          );
        },
      ),
    ).then(
      (value) {
        if (value is ToDoModel) {
          context.read<ToDoBloc>().add(
                ToDoUpdated(
                  model: value,
                  index: index,
                ),
              );
        } else if (value == 'delete') {
          context.read<ToDoBloc>().add(
                ToDoDeleted(index: index),
              );
        }
      },
    );
  }

  // Show dialog with filter selected
  Future<void> _showFilter(
    BuildContext context,
    ToDoState state,
  ) async {
    final allCategory = context.getAllCategory(state.allToDo);
    final group = state.filterSettings;

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Select ToDo only with done status
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.doneToDo,
                ),
                leading: Radio<FilterSettings>(
                  value: FilterSettings.done,
                  groupValue: group,
                  onChanged: (_) {
                    context.read<ToDoBloc>().add(
                          FilterSettingsChanged(
                            settings: FilterSettings.done,
                          ),
                        );
                    Navigator.pop(context);
                  },
                ),
              ),
              // Select ToDo only with not done status
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.notDoneToDo,
                ),
                leading: Radio<FilterSettings>(
                  value: FilterSettings.notDone,
                  groupValue: group,
                  onChanged: (_) {
                    context.read<ToDoBloc>().add(
                          FilterSettingsChanged(
                            settings: FilterSettings.notDone,
                          ),
                        );
                    Navigator.pop(context);
                  },
                ),
              ),
              // Select all ToDo
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.allToDo,
                ),
                leading: Radio<FilterSettings>(
                  groupValue: group,
                  value: FilterSettings.all,
                  onChanged: (_) {
                    context.read<ToDoBloc>().add(
                          FilterSettingsChanged(
                            settings: FilterSettings.all,
                          ),
                        );
                    Navigator.pop(context);
                  },
                ),
              ),
              // Select ToDo by category
              ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.filterCategory,
                    ),
                    DropdownButton(
                      value: allCategory.first.value,
                      items: allCategory,
                      borderRadius: BorderRadius.circular(
                        kButtonBorderRadius,
                      ),
                      onChanged: (value) {
                        context.read<ToDoBloc>().add(
                              FilterSettingsChanged(
                                settings: FilterSettings.category,
                                category: value,
                              ),
                            );
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                leading: Radio<FilterSettings>(
                  value: FilterSettings.category,
                  groupValue: group,
                  onChanged: (_) {},
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
