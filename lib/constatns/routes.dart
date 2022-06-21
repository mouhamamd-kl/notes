import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/views/Vemail_view.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';
import 'dart:developer' as devtools show log;

const loginRoute = '/login/';
const registerRoute = '/regitser/';
const notesRoute = '/notes/';
const verifyEmailRoute = '/verifiyemail/';
const homeRoute = '/home/';
void route(g, context) {
  Navigator.of(context).pushNamedAndRemoveUntil(g, (route) => false);
}
