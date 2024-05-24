import 'package:university/auth.dart';
import 'package:university/pages.dart';
import 'package:university/login_page.dart';
import 'package:flutter/material.dart';

class LoginOrNot extends StatefulWidget {
  const LoginOrNot({super.key});

  @override
  State<LoginOrNot> createState() => _LoginOrNotState();
}

class _LoginOrNotState extends State<LoginOrNot> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: Auth().authStateChanges, builder: (context, snapshot){
      if(snapshot.hasData){
        return const MainScreenWidget();
      } else{
        return const LoginPage();
      }
    });
  }
}