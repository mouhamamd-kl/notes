import 'package:flutter/material.dart';
import 'package:notes/constatns/routes.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/views/Vemail_view.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/notes/notes_view.dart';
import 'package:notes/views/notes/new_note_view.dart';
import 'package:notes/views/register_view.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const Loginview(),
        registerRoute: (context) => const RegisteView(),
        homeRoute: (context) => const HomePage(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        newNoteRoute: (context) => const NewNoteView(),
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
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // print(FirebaseAuth.instance.currentUser);
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailverified) {
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
