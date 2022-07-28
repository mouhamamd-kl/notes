import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/enums/menu_action.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/crud/notes_service.dart';
import 'dart:developer' as devtools show log;

import '../../constatns/routes.dart';
import '../../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get userEmail => AuthService.firebase().currentUser!.email!;

  late final NoteService _noteService;
  @override
  void initState() {
    _noteService = NoteService();
    _noteService.open();
    super.initState();
  }

  @override
  void dispose() {
    _noteService.close();
    super.dispose();
  }

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
      appBar:
          AppBar(centerTitle: true, title: const Text("Your Notes"), actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newNoteRoute);
            },
            icon: const Icon(Icons.add)),
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
      body: FutureBuilder(
        future: NoteService().getOrCreateUser(email: userEmail),
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: NoteService().allNotes,
                builder: (BuildContext context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return const Text("waiting for all notes........");
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
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
