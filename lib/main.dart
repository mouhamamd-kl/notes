import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/views/Vemail_view.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';
import 'constatns/routes.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtools show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      home: const HomePage(),
      routes: {
        '/login/': (context) => const Loginview(),
        '/register/': (context) => const RegisteView(),
        '/home/': (context) => const HomePage(),
        '/notes/': (context) => const NotesView(),
        '/verifiyemail/': (context) => const VerifyEmailView(),
        /*Here'  where you receive your routes, and it is also the main widget*/
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // print(FirebaseAuth.instance.currentUser);
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified == true) {
                devtools.log("email verified");
                //print("email is verified");
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const Loginview();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

final user = FirebaseAuth.instance;

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
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil(loginRoute, (_) => false);
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
          Text('Welcome ${user.currentUser?.email}'),
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

/*class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("email verification"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("please verifiy your email address"),
            TextButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                },
                child: const Text("send email verification")),
            Text("hello"),
          ],
        ),
      ),
    );
  }
}*/
