import 'package:university/auth.dart';
import 'package:university/pages.dart';
import 'package:university/login_page.dart';
import 'package:flutter/material.dart';

class SuccessLogin extends StatefulWidget {
  const SuccessLogin({super.key});

  @override
  State<SuccessLogin> createState() => _SuccessLoginState();
}

class _SuccessLoginState extends State<SuccessLogin> {
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