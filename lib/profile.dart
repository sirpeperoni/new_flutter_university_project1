
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:university/Theme/app_colors.dart';
import 'package:university/auth.dart';
import 'package:university/cart_model.dart';
import 'package:university/database_services.dart';
import 'package:university/resources/resources.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget({super.key});
  final User? user = Auth().currentUser;
  final DatabaseSercvice _databaseService = DatabaseSercvice();

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _userId(){
    return Text(user?.uid ?? 'User email');
  }

  void signOutFunc(BuildContext context) async {
    await signOut();
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.of(context).pushReplacementNamed('/start');
    }
  }

  String imageUrl = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _databaseService.getUser(),
        builder:(context, snapshot) {
          List users = snapshot.data?.docs ?? [];
          print(users[0].data());
          Users user = users[0].data();
          return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButtonHeader(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        ImagePicker imagePicker=ImagePicker();
                        XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                        if(file==null){
                          return;
                        }
                        String uniqueFileName=DateTime.now().millisecondsSinceEpoch.toString();
                        Reference referenceRoot = FirebaseStorage.instance.ref();
                        Reference referenceDirImages=referenceRoot.child("usersProfilePhoto");
                        Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);
                        try{
                          await referenceImageToUpload.putFile(File(file!.path));
                          imageUrl = await referenceImageToUpload.getDownloadURL();
                          Users newPhoto = Users(
                            name: user.name,
                            email: user.email,
                            imageUrl: imageUrl,
                            number: user.number,
                            rights: user.rights,
                            userId: user.userId
                          );
                          _databaseService.updateUser(snapshot, newPhoto);
                        }catch(error){
                            
                        }
                      }, 
                      color: AppColors.mainWhite,
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          padding: EdgeInsets.all(7.5),
                          color: AppColors.mainOrange,
                          child: Image.asset(Images.iconEdit)
                        ),
                      )
                    ),
                    IconButtonHeader(context),
                  ],
                ),
              ],
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: Image.network(user.imageUrl, height: 100, width: 100, fit: BoxFit.fill,),
              ),
            ),
            SizedBox(height: 10,),
            Center(child: Text(user.name, style: TextStyle(fontSize: 24),)),
            const Padding(
              padding: EdgeInsets.only(left: 38),
              child: Text("Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 10,),
            Padding(padding: EdgeInsets.symmetric(horizontal: 38), child: Column(children: [
              TextContainer(user: "Email: ${user.email}"),
              SizedBox(height: 15,),
              TextContainer(user: "Number: ${user.number}")
            ],),)
          ],
        );
        }
      ),
    );
  }

  IconButton IconButtonHeader(BuildContext context) {
    return IconButton(
                  onPressed: () async {
                    signOutFunc(context);
                  }, 
                  color: AppColors.mainWhite,
                  icon: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      padding: EdgeInsets.all(3),
                      color: AppColors.mainOrange,
                      child: Icon(Icons.logout)
                    ),
                  )
                );
  }
}

class TextContainer extends StatelessWidget {
  const TextContainer({
    super.key,
    required this.user,
  });

  final String user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.mainBlack.withOpacity(0.2)),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                    ]
      ),
      child: Text(user),
    );
  }
}

class BackButtonHeader extends StatelessWidget {
  const BackButtonHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(left: 25),
      onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
      icon: Image.asset(Images.backButton),
    );
  }
}