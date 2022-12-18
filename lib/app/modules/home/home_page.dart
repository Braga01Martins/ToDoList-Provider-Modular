// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_todolist_provider/app/core/notifier/default_listener_notifier.dart';
import 'package:flutter_todolist_provider/app/core/ui/theme_extensions.dart';
import 'package:flutter_todolist_provider/app/core/ui/todo_list_icons.dart';
import 'package:flutter_todolist_provider/app/models/task_filter_enum.dart';
import 'package:flutter_todolist_provider/app/modules/home/home_controller.dart';
import 'package:flutter_todolist_provider/app/modules/home/widgets/home_drawer.dart';
import 'package:flutter_todolist_provider/app/modules/home/widgets/home_filters.dart';
import 'package:flutter_todolist_provider/app/modules/home/widgets/home_header.dart';
import 'package:flutter_todolist_provider/app/modules/home/widgets/home_tasks.dart';
import 'package:flutter_todolist_provider/app/modules/home/widgets/home_week_filter.dart';
import 'package:flutter_todolist_provider/app/modules/tasks/tasks_module.dart';

class HomePage extends StatefulWidget {
  final HomeController _homeController;
  HomePage({Key? key, required HomeController homeController})
      : _homeController = homeController,
        super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: widget._homeController).listener(
      context: context,
      successCallback: (notifier, listenerInstance) {
        listenerInstance.dispose();
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget._homeController.loadTotalTasks();
      widget._homeController.findTasks(filter: TaskFilterEnum.today);
    });

    //widget._homeController.loadTotalTasks();
  }

//Qunado for *StatelasWidget temos que passar o BuildContext
  Future<void> _goToCreateTask(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation =
              /* Curves faz a animacao da transicao da tela, tem varias 
           formas de transicão com esse metodo. Ver na Docs do flutter*/
              CurvedAnimation(parent: animation, curve: Curves.easeInQuad);
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.bottomRight,
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return TasksModule().getPage('/task/create', context);
        },
      ),
    );
    widget._homeController.refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: context.primaryColor),
          backgroundColor: Color(0xFFFAFBFE),
          elevation: 0,
          actions: [
            PopupMenuButton(
              icon: Icon(TodoListIcons.filter),
              onSelected: (value) {
                widget._homeController.showOrHideFinishingTask();
              },
              itemBuilder: (_) => [
                PopupMenuItem<bool>(
                  value: true,
                  child: Text('${widget._homeController.showFinishingTask ? 'Esconder' : 'Mostrar'} Tarefas Concluidas'),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: context.primaryColor,
          onPressed: () => _goToCreateTask(context),
          child: Icon(Icons.add),
        ),
        backgroundColor: Color(0xFFFAFBFE),
        drawer: HomeDrawer(),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    minWidth: constraints.maxWidth),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeHeader(),
                        HomeFilters(),
                        HomeWeekFilter(),
                        HomeTasks(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
