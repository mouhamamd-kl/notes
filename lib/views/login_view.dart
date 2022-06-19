import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/constatns/routes.dart';

import '../main.dart';

class Loginview extends StatefulWidget {
  const Loginview({Key? key}) : super(key: key);

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  void popup(String h) {
    var snackBar1 = SnackBar(
      content: Text(h),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar1);
  }

  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("login view"),
      ),
      body: Column(
        children: [
          const Text("Enter Your Email"),
          TextField(
            decoration: InputDecoration(
              hintText: "Enter  Email",
            ),
            enableSuggestions: false,
            autocorrect: false,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
          ),
          const Text("Enter Your Password"),
          TextField(
            decoration: InputDecoration(hintText: "enter password"),
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              bool tryit = false;
              try {
                final userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                // print(userCredential);
                tryit = true;
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case "user-not-found":
                    popup(e.code);
                    break;
                  case "user-disabled":
                    popup(e.code);
                    break;
                  case "invalid-email":
                    popup(e.code);
                    break;
                  case "wrong-password":
                    popup(e.code);
                    break;
                  case "Weak password":
                    popup(e.code);
                    break;
                  case "email is already in use":
                    popup(e.code);
                    break;
                }
              }
              if (tryit == true) {
                popup("Welcome Back");
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  notesRoute,
                  (route) => false,
                );
                // route(notesRoute, context);
              }
            },
            child: const Text("Login"),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/register/', (route) => false);
              },
              child: const Text("register here bro")),
        ],
      ),
    );
  }
}
