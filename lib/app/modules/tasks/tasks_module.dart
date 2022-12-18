import 'package:flutter_todolist_provider/app/core/modules/todo_list_module.dart';
import 'package:flutter_todolist_provider/app/modules/tasks/task_create_controller.dart';
import 'package:flutter_todolist_provider/app/modules/tasks/task_create_page.dart';
import 'package:flutter_todolist_provider/app/repositories/tasks/tasks_repository.dart';
import 'package:flutter_todolist_provider/app/repositories/tasks/tasks_repository_impl.dart';
import 'package:flutter_todolist_provider/app/services/tasks/tasks_service_impl.dart';
import 'package:flutter_todolist_provider/app/services/tasks/tasks_service.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class TasksModule extends TodoListModule {
  TasksModule()
      : super(bindings: [
          Provider<TasksRepository>(
            create: (context) => TasksRepositoryImpl(
              sqliteConnectionFactory: context.read(),
            ),
          ),
          Provider<TasksService>(
            create: (context) => TasksServiceImpl(
              tasksRepository: context.read(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) =>
                TaskCreateController(tasksService: context.read()),
          ),
        ], routers: {
          '/task/create': (context) => TaskCreatePage(
                controller: context.read(),
              ),
        });
}
