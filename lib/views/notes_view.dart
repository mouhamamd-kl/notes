import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;

import '../constatns/routes.dart';
import '../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  void popup(String? h) {
    var snack;
    if (h != null) {
      snack = SnackBar(
        content: Text(h),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Notes App UI"),
          actions: [
            PopupMenuButton<MenuAction>(
                // add icon, by default "3 dot" icon
                icon: const Icon(Icons.settings),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem<MenuAction>(
                      value: MenuAction.logout,
                      child: Text("Log out"),
                    ),
                  ];
                },
                onSelected: (value) async {
                  devtools.log(value.toString());
                  switch (value) {
                    case MenuAction.logout:
                      final shoudlogout = await showLoutOutDialog(context);
                      if (shoudlogout == true) {
                        await AuthService.firebase().logOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute,
                          (_) => false,
                        );
                        // route(loginRoute, context);
                      }
                      devtools.log(shoudlogout.toString());
                      break;
                    default:
                  }
                }),
          ]),
      body: Column(
        children: [
          Text('Welcome To notes view'),
          Image.asset('assets/images/12.png')
        ],
      ),
    );
  }
}

Future<bool> showLoutOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Accpet?"),
        content: const Text("Do You Accpet"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("LogOut"),
          ),
        ],
        elevation: 100,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      );
    },
  ).then((value) => value ?? false);
}
