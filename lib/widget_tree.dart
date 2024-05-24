import 'package:university/auth.dart';
import 'package:university/pages.dart';
import 'package:flutter/material.dart';
import 'package:university/start_screen.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: Auth().authStateChanges, builder: (context, snapshot){
      if(snapshot.hasData){
        return const MainScreenWidget();
      } else{
        return const StartScreen();
      }
    });
  }
}