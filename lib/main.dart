import 'package:flutter/material.dart';
import 'package:flutter_docmgmt/screen/login_sg.dart';
void main(){

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //home: HomeScreen() , //sample
      //home: Login_New(),
      home: LoginApp(),
    );
  }
}