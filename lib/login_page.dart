
import 'package:flutter/material.dart';
import 'package:university/Theme/app_colors.dart';
import 'package:university/Theme/text_styles.dart';
import 'package:university/resources/resources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:university/auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset : false,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(height: 10),
                  ForgotPassword(),
                  SizedBox(height: 20),
                  OrLoginWith(),
                  SizedBox(height: 10),
                  ContinueWithGoogle(),
                  SizedBox(height: 5),
                  ContinueWithFacebook(),
                  SizedBox(height: 5),
                  ContinueWithTwitter(),
                  SizedBox(height: 25),
                  DontHaveAccount(),
                ],
              ),
            ),
          ],
        ),
    );
  }
}

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          
        },
        child: const Text(
            "Forgot Password?",
            style: TextStyles.ForgotPasswordStyle
        ),
      ),
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
          Text("Login to continue", style: TextStyles.welcomeStyle2,),
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
  final TextEditingController _passEmail = TextEditingController();
  final TextEditingController _passPassword = TextEditingController();

  String? errorMessage = '';


  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _passEmail.text,
        password: _passPassword.text
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  

  void _availableEmail() {
      setState(() {});
  }

  void _availablePassword() {
    setState(() {});
  }

  @override
  void initState(){
    super.initState();
    _passEmail.addListener(_availableEmail);
    _passPassword.addListener(_availablePassword);
  }

  @override
  void dispose(){
    _passEmail.dispose();
    _passPassword.dispose();
    super.dispose();
  }

  void messageEmail(BuildContext context) {
    bool check = true;
    for(var e in emails){
      if(_passEmail.text.contains(e)){
        check = false;
      }
    }
    if(check){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Почта написана неправильно!"),
        ),
      );
    }
  }

  // ignore: non_constant_identifier_names
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
                    color: _passPassword.text.isNotEmpty && _passEmail.text.isNotEmpty ? AppColors.mainOrange : AppColors.mainBlueishGrey,
                    onPressed: () async {
                      await signInWithEmailAndPassword();
                      if (FirebaseAuth.instance.currentUser != null) {
                        Navigator.of(context).pushReplacementNamed('/home');
                      }
                      messageEmail(context);
                    },
                    child: const Text(
                      'Login',
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
        const TextForFormField(text: "Password",),
        const SizedBox(height: 10),
        PasswordInputWidget(passPassword: _passPassword),
        const SizedBox(height: 20),
        const RememberMeToggleButton(),
        const SizedBox(height: 20),
        LoginButton(context),
      ],
    );
  }

  

 
}

class PasswordInputWidget extends StatelessWidget {
  const PasswordInputWidget({
    super.key,
    required TextEditingController passPassword,
  }) : _passPassword = passPassword;

  final TextEditingController _passPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: _passPassword,
        obscureText: true,
        decoration: const InputDecoration(
              hintStyle: TextStyles.hintStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              hintText: "Enter your password here",
              contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0)
          ),
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

class RememberMeToggleButton extends StatefulWidget {
  const RememberMeToggleButton({super.key});

  @override
  State<RememberMeToggleButton> createState() => _RememberMeToggleButtonState();
}

class _RememberMeToggleButtonState extends State<RememberMeToggleButton> {

  bool? _checked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      return AppColors.mainWhite;
    }
     BorderSide getBorderSideColor(Set<MaterialState> states) {
      return const BorderSide(color: AppColors.mainBlack);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                    checkColor: AppColors.mainBlack,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: _checked,
                    side: MaterialStateBorderSide.resolveWith(getBorderSideColor),
                    onChanged: (bool? value) => {
                      setState(() {
                        _checked = value;
                      })
                    }),
            ),
            const SizedBox(
                width: 10
            ),
            const Text(
                "Remember me",
                style: TextStyles.rememberMeStyle,
            ),
          ],
        ),
      ],
    );
  }
}


class OrLoginWith extends StatelessWidget {
  const OrLoginWith({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(Images.line1),
        const Text("Or login with"),
        Image.asset(Images.line1),
      ],
    );
  }
}



class ContinueWithGoogle extends StatelessWidget {
  const ContinueWithGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: Card(
              color: Colors.white,
              child: TextButton(
                onPressed: () {
                  
                },
                child: Row(
                  children: [
                    const SizedBox(width: 30,),
                    Image.asset(Images.google),
                    const SizedBox(width: 10,),
                    const Text(
                        "Continue with Google",
                        style: TextStyles.continueStyle,
                    )
                  ],
                ),
              ),
            ),
          )
        ),
      ],
    );
  }
}

class ContinueWithFacebook extends StatelessWidget {
  const ContinueWithFacebook({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: SizedBox(
              height: 50,
              child: Card(
                color: Colors.white,
                child: TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      const SizedBox(width: 30,),
                      Image.asset(Images.facebook),
                      const SizedBox(width: 10,),
                      const Text(
                          "Continue with Facebook",
                          style: TextStyles.continueStyle,
                      )
                    ],
                  ),
                ),
              ),
            )
        ),
      ],
    );
  }
}

class ContinueWithTwitter extends StatelessWidget {
  const ContinueWithTwitter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: SizedBox(
              height: 50,
              child: Card(
                color: Colors.white,
                child: TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      const SizedBox(width: 30,),
                      Image.asset(Images.twitter),
                      const SizedBox(width: 10,),
                      const Text(
                          "Continue with Twitter",
                          style: TextStyles.continueStyle,
                      )
                    ],
                  ),
                ),
              ),
            )
        ),
      ],
    );
  }
}


class DontHaveAccount extends StatelessWidget {
  const DontHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don’t have an account?",
          style: TextStyle(
            fontFamily: "Poppins",
          ),
        ),
        TextButton(
          onPressed: () {Navigator.of(context).pushReplacementNamed('/register');},
          child: const Text(" Sign Up", style: TextStyle(
            fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
          ),),
        )
      ],
    );
  }
}