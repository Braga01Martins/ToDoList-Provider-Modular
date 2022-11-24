import 'package:flutter/material.dart';
import 'package:flutter_todolist_provider/app/core/ui/theme_extensions.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

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
                CircleAvatar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Nome do usuário', style: context.textTheme.subtitle2,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
