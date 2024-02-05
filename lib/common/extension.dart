import 'package:flutter/material.dart';

import 'package:wat_do/data/model.dart';

extension Helper on BuildContext {
  // This getter allows to get a list of DropdownMenuItem
  // that contains all category
  List<DropdownMenuItem<String>> getAllCategory(List<ToDoModel> allToDo) {
    final allCategory = allToDo.map((e) => e.category).toSet().toList();

    final categoryMenuItemList =
        allCategory.map<DropdownMenuItem<String>>((String category) {
      return DropdownMenuItem<String>(
        value: category,
        child: Text(category),
      );
    }).toList();

    return categoryMenuItemList;
  }
}
