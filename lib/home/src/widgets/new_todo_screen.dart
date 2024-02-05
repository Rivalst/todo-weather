import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:wat_do/common/extension.dart';
import 'package:wat_do/common/value.dart';
import 'package:wat_do/data/model.dart';

/// Screen for creating a new ToDo item, providing input fields for name, category, and description.
/// Includes a dropdown for selecting a category and a "Done"
/// button to confirm the creation of the new ToDo.
class NewToDoScreen extends StatefulWidget {
  const NewToDoScreen({
    required this.allToDo,
    super.key,
  });

  final List<ToDoModel> allToDo;

  @override
  State<NewToDoScreen> createState() => _NewToDoScreenState();
}

class _NewToDoScreenState extends State<NewToDoScreen> {
  @override
  void initState() {
    _controllerTitle = TextEditingController();
    _controllerDescription = TextEditingController();
    _controllerCategory = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allCategory = context.getAllCategory(widget.allToDo);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.newToDo,
        ),
        actions: [
          // button for apply changes in ToDo item
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                ToDoModel(
                  name: _controllerTitle.text,
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextField(
              controller: _controllerTitle,
              maxLength: kToDoMaxNameLength,
              decoration: InputDecoration(
                label: Text(
                  AppLocalizations.of(context)!.title,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: kSmallPadding,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const Gap(kSmallPadding),
            TextField(
              controller: _controllerCategory,
              decoration: InputDecoration(
                label: Text(
                  AppLocalizations.of(context)!.category,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: kSmallPadding,
                ),
                border: const OutlineInputBorder(),
                suffix: allCategory.isEmpty
                    ? null
                    : DropdownButton(
                        value: allCategory.first.value,
                        items: allCategory,
                        borderRadius: BorderRadius.circular(
                          kButtonBorderRadius,
                        ),
                        onChanged: (value) {
                          _controllerCategory.text = value!;
                        },
                      ),
              ),
            ),
            const Gap(kSmallPadding),
            Expanded(
              child: TextField(
                controller: _controllerDescription,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.description,
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

  late TextEditingController _controllerTitle;

  late TextEditingController _controllerDescription;

  late TextEditingController _controllerCategory;
}
