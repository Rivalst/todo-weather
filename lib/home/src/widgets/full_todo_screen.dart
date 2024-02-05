import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:wat_do/common/extension.dart';
import 'package:wat_do/common/value.dart';
import 'package:wat_do/data/model.dart';

/// Screen for updating an existing ToDo item, allowing users to modify name, category, and description.
/// Includes buttons for applying changes and deleting the ToDo item.
class FullToDoScreen extends StatefulWidget {
  const FullToDoScreen({
    required this.model,
    required this.allToDo,
    super.key,
  });

  final ToDoModel model;
  final List<ToDoModel> allToDo;

  @override
  State<FullToDoScreen> createState() => _ToDoFieldState();
}

class _ToDoFieldState extends State<FullToDoScreen> {
  @override
  void initState() {
    _controllerName = TextEditingController();
    _controllerDescription = TextEditingController();
    _controllerCategory = TextEditingController();

    _controllerName.text = widget.model.name;
    _controllerDescription.text = widget.model.description;
    _controllerCategory.text = widget.model.category;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allCategory = context.getAllCategory(widget.allToDo);
    final currentCategory = allCategory
        .firstWhere((element) => element.value == widget.model.category)
        .value;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.updateToDo,
        ),
        actions: [
          // button for apply changes in ToDo item
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                ToDoModel(
                  name: _controllerName.text,
                  description: _controllerDescription.text,
                  category: _controllerCategory.text,
                  isDone: false,
                ),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.done,
            ),
          ),
          // button for delete ToDo item
          IconButton(
            onPressed: () {
              return Navigator.pop(context, 'delete');
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextField(
              controller: _controllerName,
              maxLength: kToDoMaxNameLength,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: kSmallPadding,
                ),
                border: const OutlineInputBorder(),
                label: Text(AppLocalizations.of(context)!.title),
              ),
            ),
            const Gap(kSmallPadding),
            TextField(
              controller: _controllerCategory,
              decoration: InputDecoration(
                label: Text(
                  AppLocalizations.of(context)!.category,
                ),
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: kSmallPadding),
                suffix: Padding(
                  padding: const EdgeInsets.all(kSmallPadding),
                  child: DropdownButton(
                    value: currentCategory,
                    items: allCategory,
                    borderRadius: BorderRadius.circular(
                      kButtonBorderRadius,
                    ),
                    onChanged: (value) {
                      _controllerCategory.text = value.toString();
                    },
                  ),
                ),
              ),
            ),
            const Gap(kSmallPadding),
            Expanded(
              child: TextField(
                controller: _controllerDescription,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.description,
                  labelStyle: const TextStyle(),
                  border: const OutlineInputBorder(),
                ),
                expands: true,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  late TextEditingController _controllerName;

  late TextEditingController _controllerDescription;

  late TextEditingController _controllerCategory;
}
