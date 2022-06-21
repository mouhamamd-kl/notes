import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/constatns/routes.dart';
import 'dart:developer' as devtools show log;

import 'package:notes/main.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  void popup(String h) {
    var snackbar = SnackBar(content: Text(h));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
        actions: [
          PopupMenuButton<String>(
              icon: const Icon(Icons.settings),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<String>(
                    value: "Restart",
                    child: Text("Log out"),
                  )
                ];
              },
              onSelected: (value) async {
                devtools.log(value.toString());
                switch (value) {
                  case "Restart":
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                    // route(loginRoute, context);
                    break;
                  default:
                }
              })
        ],
      ),
      body: Column(
        children: [
          const Text(
              "We've sent you an email verification please open it to verify your email account"),
          (const Text(
              "if you haven't recived a verification email yet ,press the button below")),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                // Future<void> sendEmailVerification([
                //   ActionCodeSettings? actionCodeSettings,
                // ]) async {
                //   await user?.sendEmailVerification(actionCodeSettings);
                // }
                await user?.sendEmailVerification();
                if (user != null) {
                  if (user.emailVerified == true) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                  }
                }
              },
              child: const Text("Send Email Verification")),
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text("Restart")),
        ],
      ),
    );
  }
}
