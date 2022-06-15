import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text("hello everybodylotion"),
        leading: const Icon(Icons.account_circle_outlined),
        leadingWidth: 100,
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    const Text("enter your email"),
                    TextField(
                      controller: _email,
                    ),
                    const Text("enter your"),
                    TextField(
                      controller: _password,
                    ),
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                          print(userCredential);
                        } on FirebaseAuthException catch (e) {
                          switch (e.code) {
                            case "email-already-in-use":
                              popup(e.code);
                              print(e.code);
                              break;
                            case "invalid-email":
                              popup(e.code);
                              print(e.code);
                              break;
                            case "operation-not-allowed":
                              popup(e.code);
                              print(e.code);
                              break;
                            case "weak-password":
                              popup(e.code);
                              print(e.code);
                              break;
                          }
                        }
                      },
                      child: const Text("hello people"),
                    ),
                  ],
                );
              default:
                return const Text("Loading");
                break;
            }
          }),
    );
  }
}
