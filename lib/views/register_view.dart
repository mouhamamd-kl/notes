import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/constatns/routes.dart';

import '../main.dart';

class RegisteView extends StatefulWidget {
  const RegisteView({Key? key}) : super(key: key);

  @override
  State<RegisteView> createState() => _RegisteViewState();
}

class _RegisteViewState extends State<RegisteView> {
  void popup(String h) {
    var snackbar = SnackBar(content: Text(h));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("register view"),
      ),
      body: Column(
        children: [
          const Text("Enter Your Email"),
          TextField(
            controller: _email,
          ),
          const Text("Enter Your Password"),
          TextField(
            controller: _password,
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                //print(userCredential);
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case "email-already-in-use":
                    popup(e.code);
                    //print(e.code);
                    break;
                  case "invalid-email":
                    popup(e.code);
                    // print(e.code);
                    break;
                  case "operation-not-allowed":
                    popup(e.code);
                    // print(e.code);
                    break;
                  case "weak-password":
                    popup(e.code);
                    // print(e.code);
                    break;
                }
              }
            },
            child: const Text("register"),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  loginRoute,
                  (route) => false,
                );
                //route(loginRoute, context);
              },
              child: const Text("log in here")),
        ],
      ),
    );
  }
}
