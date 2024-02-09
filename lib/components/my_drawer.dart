import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Center(
          child: Center(
            child: CupertinoSwitch(
              value: Provider.of<ThemeProvider>(context).isDarkMode, 
              onChanged: (value){
                // Hacemos el llamado a nuestro provider para cambiar el tema
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              }),
          ),
        ),
      );
  }
}