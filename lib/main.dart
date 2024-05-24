import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university/cart.dart';
import 'package:university/cart_model.dart';
import 'package:university/login_page.dart';
import 'package:university/pages.dart';
import 'package:university/product_details.dart';
import 'package:university/register_page.dart';
import 'package:university/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:university/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid ?
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBlUkcCg-qGB0si-AwsJevCC_FIrX3o-3A',
        appId: '1:905920161280:android:711ea0c00919015b42dae5', 
        messagingSenderId: '905920161280',
        projectId: 'universityflutterproject',
        storageBucket: "universityflutterproject.appspot.com",
        )
    )
  :
    await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => CartModel(),
      child: MaterialApp(
      routes: {
        '/login_or_not': (context) => const WidgetTree(),
        '/start': (context) => const StartScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home':(context) => const MainScreenWidget(),
        '/home/product_details': (context) {
            final arguments = ModalRoute.of(context)?.settings.arguments;
            if(arguments is Product){
              return ProductDetails(product: arguments,);
            } else {
              return const MainScreenWidget();
            }
        },
        '/cart':(context) => const CartWidget()
      },
      initialRoute: '/login_or_not',
    ),
    );
  }
}
