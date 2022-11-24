// ignore_for_file: prefer_const_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app/app_module.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AppModule());
}
