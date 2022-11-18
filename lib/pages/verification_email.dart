import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nest_music/pages/home_page.dart';

class VerificationEmail extends StatefulWidget {
  static String id = 'verification_email';

  @override
  State<VerificationEmail> createState() => _VerificationEmailState();
}

class _VerificationEmailState extends State<VerificationEmail> {
  bool isEmailVerified = false;
  Timer? timer;
  bool resendEmial = false;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified){
      verifierEmail();

      timer = Timer.periodic(
        Duration(seconds: 5),
          (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => isEmailVerified
  ? Homepage()
      : Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Un email de vérification a été envoyé',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center),
              SizedBox(height: 30,),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                icon: Icon(Icons.email,size: 30,),
                label: Text("Renvoyer l'e-mail",
                style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                onPressed: (){
                  if(resendEmial){
                    verifierEmail();
                  }
                  else{
                    this.deactivate();
                  }
                },
              ),
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
              )
            ],
          ),
        ),
  );

  Future verifierEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => resendEmial = false);
      await Future.delayed(Duration(seconds: 10));
      setState(() => resendEmial = true);
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          action: SnackBarAction(
            label: 'Action',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
    }
  }

  Future checkEmailVerified()  async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified){
      timer?.cancel();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Votre e-mail a été vérifié! Bienvenue dans Nest Musique !"),
          action: SnackBarAction(
            label: 'Action',
            textColor: Colors.blueAccent,
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
    }
  }
}
