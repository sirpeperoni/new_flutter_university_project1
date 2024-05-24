import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:university/Theme/text_styles.dart';
import 'package:university/cart_model.dart';
import 'package:university/database_services.dart';
import 'package:university/resources/resources.dart';
import 'package:university/Theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:university/auth.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset : false,
      body: Column(
        children: [
            SizedBox(height: 25,),      
            HeaderWithBackButton(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WelcomeWidget(),
                  EmailPasswordInput(),
                  SizedBox(height: 10,),
                  HaveAccount()
                ],
              ),
            ),
        ],
      )
    );
  }
}


class HeaderWithBackButton extends StatelessWidget {
  const HeaderWithBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BackButtonHeader(),
              SizedBox(width: 35),
              Header(),
            ],
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

class BackButtonHeader extends StatelessWidget {
  const BackButtonHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(left: 25),
      onPressed: () => Navigator.of(context).pushReplacementNamed('/start'),
      icon: Image.asset(Images.backButton),
    );
  }
}
class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 16, bottom: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome back!", style: TextStyles.welcomeStyle1,),
          Text("Register to continue", style: TextStyles.welcomeStyle2,),
        ],
      ),
    );
  }
}


class EmailPasswordInput extends StatefulWidget {
  const EmailPasswordInput({super.key});

  @override
  State<EmailPasswordInput> createState() => _EmailPasswordInputState();
}

class _EmailPasswordInputState extends State<EmailPasswordInput> {
  final emails = ["@gmail.com", "@yandex.ru", "@mail.com", "@rambler.ru", "@yahoo.com"];
  final uniqueSymbols = ['/', '.', ',', '!', '@', '#', '%', '^', '&', '*', '(', ')', '-', '=', '+'];
  final TextEditingController _passEmail = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool eightCheck = false;
  bool uniqueCharactersCheck = false;
  String? errorMessage = '';
  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _passEmail.text,
        password: _passwordController.text
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _passEmail.text,
        password: _passwordController.text
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }


  String country = Images.ru;
  List _countries = [];
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('images/countries.json');
    final data = await json.decode(response);
    setState(() {
        _countries = data;
    });
  }
  void _availableEmail() {
      setState(() {});
  }

  void _availablePhone() {
    int select = 0;
    List countriesNumbers = [];
    for(int i = 0; i < _countries.length; i++){
      if(_phoneController.text.contains(_countries[i]["dial_code"])){
        countriesNumbers.add(_countries[i]);
      }
    }
    int max = 0;
    for(int i = 0; i < countriesNumbers.length; i++){
      if(max < countriesNumbers[i]["dial_code"].length){
        select = i;
        max = countriesNumbers[i]["dial_code"].length;
      }
    }
    // ignore: prefer_interpolation_to_compose_strings
    country = '${'images/' + countriesNumbers[select]["alpha_2_code"].toLowerCase()}.png';
    setState(() {});
  }

  void _availablePassword(){
    eightCheck = _passwordController.text.length >= 8 ? true : false; 
    for(int i = 0; i < uniqueSymbols.length; i++){
      if(_passwordController.text.contains(uniqueSymbols[i])){
        uniqueCharactersCheck = true;
        break;
      }else{
        uniqueCharactersCheck = false;
      }
    }
    setState(() {});
  }

  @override
  void initState(){
    super.initState();
     readJson();   
    _passEmail.addListener(_availableEmail);
    _phoneController.addListener(_availablePhone);
    _passwordController.addListener(_availablePassword);
  }

  @override
  void dispose(){
    _passEmail.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
final DatabaseSercvice _databaseService = DatabaseSercvice();
    Row LoginButton(BuildContext context) {
    return Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child:
              ClipRRect(
                borderRadius: BorderRadius.circular(150),
                child: SizedBox(
                  height: 46,
                  child: MaterialButton(
                    color: _phoneController.text.isNotEmpty && _passEmail.text.isNotEmpty && eightCheck && uniqueCharactersCheck  ? AppColors.mainOrange : AppColors.mainBlueishGrey,
                    onPressed: () async {
                      await createUserWithEmailAndPassword();
                      await signInWithEmailAndPassword();
                      String name = '';
                      outerLoop:
                      for(int i = 0; i < _passEmail.text.length; i++){
                        if(_passEmail.text[i] != '@'){
                          name+=_passEmail.text[i];
                        }else{
                          break outerLoop;
                        }
                      }
                      final User? user = Auth().currentUser;
                      Users newUser = Users(
                            name: name,
                            email: _passEmail.text,
                            imageUrl: "https://firebasestorage.googleapis.com/v0/b/universityflutterproject.appspot.com/o/usersProfilePhoto%2Fcsm_personen_leer_db3725d3ab.jpg?alt=media&token=a28c9f3d-d91d-45aa-bd9b-64f569a95e35",
                            number: _phoneController.text,
                            rights: "user",
                            userId: user!.uid
                      );
                      _databaseService.addUser(newUser);
                      if (FirebaseAuth.instance.currentUser != null) {
                        Navigator.of(context).pushReplacementNamed('/home');
                      }
                    },
                    child: const Text(
                      "Register",
                      style: TextStyles.buttonText,
                    ),
                  ),
                ),
              ),
              ),
       
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextForFormField(text: "Email",),
        const SizedBox(height: 10),
        EmailInputWidget(passEmail: _passEmail),
        const SizedBox(height: 20),
        const TextForFormField(text: "Phone Number",),
        const SizedBox(height: 10),
        PhoneNumberInputWidget(phoneController: _phoneController, country: country,),
        const SizedBox(height: 20),
        const TextForFormField(text: "Password",),
        const SizedBox(height: 10),
        PasswordInputWidget(passwordController: _passwordController,),
        const SizedBox(height: 20),
        const TextForFormField(text: "Confirm Password",),
        const SizedBox(height: 10),
        ConfirmPasswordInputWidget(confirmPasswordController: _confirmPasswordController),
        const SizedBox(height: 20),
        RequireEight(text: "At least 8 character", image: AssetImage(eightCheck ? Images.newMoon1 : Images.newMoon2), eightCheck: eightCheck),
        const SizedBox(height: 10),
        RequireUnique(text: "Include unique character", image: AssetImage(uniqueCharactersCheck ? Images.newMoon1 : Images.newMoon2), uniqueCharactersCheck: uniqueCharactersCheck,),
        const SizedBox(height: 20,),
        const Row(
          children: [
            Text("By continuing, you afree to our ", style: TextStyles.countStyle,),
            Text("Terms Of Service", style: TextStyles.termsStyle,)
          ],
        ),
        const Row(
          children: [
            Text("and ", style: TextStyles.countStyle,),
            Text("Privacy Policy", style: TextStyles.termsStyle,)
          ],
        ),
        const SizedBox(height: 20,),
        LoginButton(context),
      ],
    );
  }
  

 
}


class RequireEight extends StatelessWidget {
  const RequireEight({
    super.key,
    required this.text,
    required this.image,
    required this.eightCheck,
  });
  final String text;
  final ImageProvider image;
  final bool eightCheck;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(image: image),
        const SizedBox(width: 10,),
        Text(text, style: eightCheck ? TextStyles.confirmErrorText : TextStyles.notErrorText,)
      ],
    );
  }
}

class RequireUnique extends StatelessWidget {
  const RequireUnique({
    super.key,
    required this.text,
    required this.image,
    required this.uniqueCharactersCheck,
  });
  final String text;
  final ImageProvider image;
  final bool uniqueCharactersCheck;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(image: image),
        const SizedBox(width: 10,),
        Text(text, style: uniqueCharactersCheck ? TextStyles.confirmErrorText : TextStyles.notErrorText,)
      ],
    );
  }
}

class TextForFormField extends StatelessWidget {
  const TextForFormField({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text, style: TextStyles.welcomeStyle2,
      )
      ],
    );
  }
}

class EmailInputWidget extends StatelessWidget {
  const EmailInputWidget({
    super.key,
    required TextEditingController passEmail,
  }) : _passEmail = passEmail;

  final TextEditingController _passEmail;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: _passEmail,
        decoration: const InputDecoration(
              hintStyle: TextStyles.hintStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              hintText: "Enter your email here",
              contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0)
          ),
    );
  }
}


class PhoneNumberInputWidget extends StatelessWidget {
  const PhoneNumberInputWidget({
    super.key,
    required this.country,
    required TextEditingController phoneController,
  }) : _phoneController = phoneController;

  final TextEditingController _phoneController;
  // ignore: prefer_typing_uninitialized_variables
  final country;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [TextFormField(
          inputFormatters: [
            LengthLimitingTextInputFormatter(12),
          ],
          keyboardType: TextInputType.phone,
          controller: _phoneController,
          decoration: const InputDecoration(
                hintStyle: TextStyles.hintStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                hintText: "+7-xxx-xxx-xx-xx",
                contentPadding: EdgeInsets.fromLTRB(45, 0, 0, 0)
            ),
      ),
      Positioned(
        top: 10,
        left: 10,
        child: Image(
          width: 30,
          height: 30,
          image: AssetImage(country)
        ),
      )
      ]
    );
  }
}


class PasswordInputWidget extends StatelessWidget {
  const PasswordInputWidget({
    super.key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(
                hintStyle: TextStyles.hintStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                hintText: "***********",
                contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0)
            ),
      ),
      const Positioned(
        right: 10,
        top: 15,
        child: Image(image: AssetImage(Images.iconEyeOff_)
        )
      )
      ],
    );
  }
}

class ConfirmPasswordInputWidget extends StatelessWidget {
  const ConfirmPasswordInputWidget({
    super.key,
    required TextEditingController confirmPasswordController,
  }) : _confirmPasswordController = confirmPasswordController;

  final TextEditingController _confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [TextFormField(
          controller: _confirmPasswordController,
          decoration: const InputDecoration(
                hintStyle: TextStyles.hintStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                hintText: "***********",
                contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0)
            ),
      ),
      const Positioned(
        right: 10,
        top: 15,
        child: Image(image: AssetImage(Images.iconEyeOff_)
        )
      )
      ],
    );
  }
}


class HaveAccount extends StatelessWidget {
  const HaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already a member?",
          style: TextStyle(
            fontFamily: "Poppins",
          ),
        ),
        TextButton(
          onPressed: () {Navigator.of(context).pushReplacementNamed('/login');},
          child: const Text(" Login", style: TextStyle(
            fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
          ),),
        )
      ],
    );
  }
}