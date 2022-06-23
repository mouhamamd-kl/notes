import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailverified;
  const AuthUser(this.isEmailverified);
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
