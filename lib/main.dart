import 'package:flutter/material.dart';
import 'principal.dart';

void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    // Remove the debug banner
    debugShowCheckedModeBanner: false,
    title: "Aplicação com SQLlite",

    theme: ThemeData(
    primarySwatch: Colors.orange,
    ),
    home: const Principal());
  }
}

