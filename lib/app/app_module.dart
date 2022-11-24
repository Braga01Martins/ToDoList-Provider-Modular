import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todolist_provider/app/core/auth/auth_provider.dart';
import 'package:flutter_todolist_provider/app/repositories/user/user_repository.dart';
import 'package:flutter_todolist_provider/app/repositories/user/user_repository_impl.dart';
import 'package:flutter_todolist_provider/app/services/user/user_service.dart';
import 'package:flutter_todolist_provider/app/services/user/user_service_impl.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'app_widget.dart';
import 'core/database/sqlite_connection_factory.dart';

//dentro da classe AppModule ficam todas as classes
//onde vao ser compartilhada por todos os módulos

class AppModule extends StatelessWidget {
  const AppModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => FirebaseAuth.instance),
        Provider(
          create: (_) => SqliteConnectionFactory(),
          lazy: false, //o 'lazy:false' faz com que, quando cair nesse metodo já
          //vai instanciar essa classe e fazer toda
          //estrutura do migration e deixa a conexão disponivel para ser utilizada.,
        ),
        Provider<UserRepository>(
          create: (context) => UserRepositoryImpl(firebaseAuth: context.read()),
        ),
        Provider<UserService>(
          create: (context) => UserServiceImpl(userRepository: context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
              firebaseAuth: context.read(), userService: context.read())..loadListener(),
              lazy: false,
        ),
      ],
      child: const AppWidget(),
    );
  }
}
