import 'package:flutter/material.dart';
import 'package:university/Theme/app_colors.dart';
import 'package:university/Theme/text_styles.dart';
import 'package:university/resources/resources.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30,),          
          Header(),
          SizedBox(height: 20,), 
          Advert(),
          SizedBox(height: 40,),
          StartPageButton(vertical: 12.0,horizontal: 100.0, text: "Login", color: AppColors.mainOrange, navigatorText: '/login',),
          SizedBox(height: 20,),
          StartPageButton(vertical: 12.0,horizontal: 90.0, text: "Sign up", color: AppColors.mainBlueishGrey,navigatorText: '/register',),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(image: AssetImage(Images.ellipse1)),
        SizedBox(width: 10,),
        Text(
          "bakery and patisserie", 
          style: TextStyles.headerText,
        )
      ],
    );
  }
}

class Advert extends StatelessWidget {
  const Advert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: const Image(
            image: AssetImage(Images.bannerPhoto)
          )
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: const Image(
            image: AssetImage(Images.bannerShades)
          )
        ),
        const Positioned(
          left: 20,
          bottom: 60,
          child: Text(
            "Delightful Baked",
            style: TextStyles.advertiseText,
          )
        ),
        const Positioned(
          left: 20,
          bottom: 20,
          child: Text(
            "Creations",
            style: TextStyles.advertiseText,
          )
        ),
      ],
    );
  }
}

class StartPageButton extends StatelessWidget {
  final String text;
  final double vertical;
  final double horizontal;
  final Color color;
  final String navigatorText;
  const StartPageButton({
    super.key,
    required this.text,
    required this.vertical,
    required this.horizontal,
    required this.color,
    required this.navigatorText
  });


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: MaterialButton(
        padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
        color:color,
        onPressed: () {Navigator.of(context).pushReplacementNamed(navigatorText);},
        child: Text(text, style: TextStyles.buttonText,),
      ),
    );
  }
}