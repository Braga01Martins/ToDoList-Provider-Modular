// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_todolist_provider/app/core/auth/auth_provider.dart';
import 'package:flutter_todolist_provider/app/core/ui/messages.dart';
import 'package:flutter_todolist_provider/app/core/ui/theme_extensions.dart';
import 'package:flutter_todolist_provider/app/services/user/user_service.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  final nameVN = ValueNotifier<String>('');
  HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.primaryColor.withAlpha(70),
            ),
            child: Row(
              children: [
                // Se tiver uma atualizacao somete da foto o selector rebuilda somete ela,
                //Se tiver uma atualizacao somete do nome o selector rebuilda somete ele,
                Selector<AuthProvider, String>(
                    selector: (context, authProvider) {
                  return authProvider.user?.photoURL ??
                      'https://w1.pngwing.com/pngs/933/945/png-transparent-social-media-icons-avatar-user-profile-login-black-circle-silhouette-symbol.png';
                }, builder: (_, value, __) {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(value),
                  );
                }),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Selector<AuthProvider, String>(
                        selector: (context, authProvider) {
                      return authProvider.user?.displayName ?? 'Não informado';
                    }, builder: (_, value, __) {
                      return Text(value, style: context.textTheme.subtitle2);
                    }),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text('Alterar Nome'),
                      content: TextField(
                        onChanged: (value) => nameVN.value = value,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                            onPressed: () async {
                              final nameValue = nameVN.value;
                              if (nameValue.isEmpty) {
                                Messages.of(context)
                                    .showError('Nome Obrigatório!');
                              } else {
                                Loader.show(context);
                                await context
                                    .read<UserService>()
                                    .updateDisplayName(nameValue);
                                Loader.hide();
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text('Alterar')),
                      ],
                    );
                  });
            },
            title: Text('Alterar Nome'),
          ),
          ListTile(
            onTap: () => context.read<AuthProvider>().logout(),
            title: Text('Sair'),
          ),
        ],
      ),
    );
  }
}
