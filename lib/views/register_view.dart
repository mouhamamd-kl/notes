import 'package:flutter/material.dart';
import 'package:notes/constatns/routes.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/views/show_error_dialog.dart';

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
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                //final user = AuthService.firebase().currentUser;
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
                //print(userCredential);
              } on EmailAlreadyInUseAuthException catch (e) {
                await showerrordialog(
                  context,
                  "email-already-in-use",
                );
                popup(e.toString());
              } on InvalidEmailAuthException {
                await showerrordialog(
                  context,
                  'Invalid email',
                );
              } on WeakPasswordAuthException {
                await showerrordialog(
                  context,
                  'Weak Password',
                );
              } on GenericAuthException {
                await showerrordialog(
                  context,
                  "Authentication error",
                );
              } /* on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case "email-already-in-use":
                    showerrordialog(
                      context,
                      "email-already-in-use",
                    );
                    // popup(e.code);
                    //print(e.code);
                    break;
                  case "invalid-email":
                    showerrordialog(
                      context,
                      "invalid-email",
                    );
                    // popup(e.code);
                    // print(e.code);
                    break;
                  case "operation-not-allowed":
                    showerrordialog(
                      context,
                      "operation-not-allowed",
                    );
                    //popup(e.code);
                    // print(e.code);
                    break;
                  case "weak-password":
                    showerrordialog(
                      context,
                      "weak-password",
                    );
                    // popup(e.code);
                    // print(e.code);
                    break;
                }
              } catch (e) {
                showerrordialog(context, "Error : ${e.toString()}");
              }*/
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
