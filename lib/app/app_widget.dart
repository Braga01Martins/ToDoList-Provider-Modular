import 'package:flutter/material.dart';
import 'package:flutter_todolist_provider/app/core/navigator/todo_list_navigator.dart';
import 'package:flutter_todolist_provider/app/core/ui/todo_list_ui_config.dart';
import 'package:flutter_todolist_provider/app/modules/auth/login/login_page.dart';
import 'package:flutter_todolist_provider/app/modules/home/home_module.dart';
import 'package:flutter_todolist_provider/app/modules/home/home_page.dart';
import 'core/database/sqlite_adm_connection.dart';
import 'modules/auth/auth_module.dart';
import 'modules/splash/splash_page.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final sqliteAdmConnection = SqliteAdmConnection();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(sqliteAdmConnection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(sqliteAdmConnection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List Provider',
      initialRoute: '/login',
      theme: TodoListUiConfig.theme,
      navigatorKey: TodoListNavigator.navigatorKey,
      routes: {
        ...AuthModule().routers,
        ...HomeModule().routers,
      },
      home: SplashPage(),
    );
  }
}
