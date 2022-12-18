import 'package:flutter_todolist_provider/app/core/modules/todo_list_module.dart';
import 'package:flutter_todolist_provider/app/modules/home/home_controller.dart';
import 'package:flutter_todolist_provider/app/modules/home/home_page.dart';
import 'package:provider/provider.dart';
import '../../repositories/tasks/tasks_repository.dart';
import '../../repositories/tasks/tasks_repository_impl.dart';
import '../../services/tasks/tasks_service.dart';
import '../../services/tasks/tasks_service_impl.dart';

class HomeModule extends TodoListModule {
  HomeModule()
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
            create: (context) => HomeController(tasksService: context.read()),
          )
        ], routers: {
          '/home': (context) => HomePage(homeController: context.read()),
        });
}
