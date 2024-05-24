import 'package:flutter/material.dart';
import 'package:university/Theme/app_colors.dart';

abstract class TextStyles{
  static const headerText = TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w100,
                  color: AppColors.mainDarkGrey,
                  fontFamily: 'Rochester',
                );

  static const advertiseText = TextStyle(
                fontSize: 27,
                color: AppColors.mainWhite,
                fontWeight: FontWeight.bold ,
                fontFamily: 'Poppins'
              );
  static const buttonText = TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                );
  static const welcomeStyle1 = TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  );
  static const welcomeStyle2 = TextStyle(
                    fontSize: 10,
                    fontFamily: 'Poppins',
                  );

  static const hintStyle = TextStyle(
                      fontSize: 12,
                      color: AppColors.mainLightGrey,
                    );
  static const rememberMeStyle = TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                );
  // ignore: constant_identifier_names
  static const ForgotPasswordStyle = TextStyle(
                          fontFamily: "Poppins",
                          color: AppColors.mainBlack,
                          fontWeight: FontWeight.w100
                        );
  static const continueStyle = TextStyle(
                            color: AppColors.mainBlack
                        );

  static const notErrorText = TextStyle(
    color: AppColors.mainBlack,
  );
  static const confirmErrorText = TextStyle(
    color: AppColors.mainGreen,
  );
  static const termsStyle = TextStyle(
    color: AppColors.mainOrange,
    fontSize: 12,
    fontFamily: "Poppins",
              decoration: TextDecoration.underline,
          );
    static const countStyle = TextStyle(
    color: AppColors.mainBlack,
    fontSize: 12,
    fontFamily: "Poppins",
          );
}