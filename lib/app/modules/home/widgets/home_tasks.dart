// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_todolist_provider/app/core/ui/theme_extensions.dart';
import 'package:flutter_todolist_provider/app/models/task_filter_enum.dart';
import 'package:flutter_todolist_provider/app/models/task_model.dart';
import 'package:flutter_todolist_provider/app/modules/home/home_controller.dart';
import 'package:flutter_todolist_provider/app/modules/home/widgets/task.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class HomeTasks extends StatelessWidget {
  const HomeTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Selector<HomeController, String>(
            selector: (context, controller) {
              return controller.filterSelected.description;
            },
            builder: (context, value, child) {
              return Text(
                'TASK\'S $value',
                style: context.titleStyle,
              );
            },
          ),
          Column(
            children: context
                .select<HomeController, List<TaskModel>>(
                    (controller) => controller.filteredTasks)
                .map((t) => Task(model: t,))
                .toList(),
          )
        ],
      ),
    );
  }
}
