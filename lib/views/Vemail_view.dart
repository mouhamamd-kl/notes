import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';

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
      ),
      body: Column(
        children: [
          (const Text("enter your email")),
          TextField(),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                Future<void> sendEmailVerification([
                  ActionCodeSettings? actionCodeSettings,
                ]) async {
                  await user?.sendEmailVerification(actionCodeSettings);
                }
              },
              child: const Text("Send Email Verification"))
        ],
      ),
    );
  }
}
