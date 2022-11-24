// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_todolist_provider/app/core/notifier/default_listener_notifier.dart';
import 'package:flutter_todolist_provider/app/core/ui/theme_extensions.dart';
import 'package:flutter_todolist_provider/app/core/validators/validators.dart';
import 'package:flutter_todolist_provider/app/core/widget/todo_list_field.dart';
import 'package:flutter_todolist_provider/app/core/widget/todo_list_logo.dart';
import 'package:flutter_todolist_provider/app/modules/auth/register/register_controller.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _confirmPasswordEC = TextEditingController();

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    _confirmPasswordEC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // context.read<RegisterController>().addListener(() {
    //   final controller = context.read<RegisterController>();
    //   var sucess = controller.sucess;
    //   var error = controller.error;
    //   if (sucess) {
    //     Navigator.of(context).pop();
    //   } else if (error != null && error.isNotEmpty) {

    //   }
    // });
    super.initState();
    final defaultListener = DefaultListenerNotifier(
        changeNotifier: context.read<RegisterController>());
    defaultListener.listener(
      context: context,
     everCallback: (notifier, listenerInstance){},
      successCallback: (notifier, listenerInstance) {
        listenerInstance.dispose();
        Navigator.of(context).pop();
      },
      errorCallback: (notifier, listenerInstance) {
        print('Deu RUIM!!!!!!');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Todo List',
              style: TextStyle(fontSize: 10, color: context.primaryColor),
            ),
            Text(
              'Cadastro',
              style: TextStyle(fontSize: 15, color: context.primaryColor),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: ClipOval(
            child: Container(
              color: context.primaryColor.withAlpha(20),
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_ios_outlined,
                size: 20,
                color: context.primaryColor,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.width * .5,
            child: FittedBox(
              child: TodoListLogo(),
              fit: BoxFit.fitHeight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TodoListField(
                    label: 'E-mail',
                    controller: _emailEC,
                    validator: Validatorless.multiple([
                      Validatorless.required('E-mail obrigatório'),
                      Validatorless.email('E-mail inválido'),
                    ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TodoListField(
                    label: 'Senha',
                    obscureText: true,
                    controller: _passwordEC,
                    validator: Validatorless.multiple([
                      Validatorless.required('Senha Obrigatória'),
                      Validatorless.min(
                          6, 'Senha deve ter pelo menos 6 caracteres')
                    ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TodoListField(
                    label: 'confirmar Senha',
                    obscureText: true,
                    controller: _confirmPasswordEC,
                    validator: Validatorless.multiple([
                      Validatorless.required('Confirma Senha Obrigatória'),
                      Validators.compare(
                          _passwordEC, 'Senha diferente de confirma senha'),
                    ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        final formValid =
                            _formKey.currentState?.validate() ?? false;
                        if (formValid) {
                          final email = _emailEC.text;
                          final password = _passwordEC.text;
                          context
                              .read<RegisterController>()
                              .registerUser(email, password);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Salvar'),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
