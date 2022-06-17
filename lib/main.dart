import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';
import 'firebase_options.dart';

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
        'home': (context) => const HomePage(),
        /*Here's where you receive your routes, and it is also the main widget*/
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
            // final user = FirebaseAuth.instance.currentUser;
            // final emailverived =
            //     FirebaseAuth.instance.currentUser?.emailVerified ?? false;
            // if (user?.emailVerified == true) {
            //   return const Text("Done");
            //   print("you are verified user");
            // } else {
            //   print("not verified please verified");
            //   return VerifyEmailView();
            // }
            // return const Text("Done");
            return const Loginview();
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
