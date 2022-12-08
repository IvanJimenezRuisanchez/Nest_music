import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nest_music/main.dart';
import 'package:sizer/sizer.dart';

class SignUp extends StatefulWidget {
  static String id = 'sign_up';

  @override
  _SignUpState createState() => _SignUpState();
}



class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final userNameController = TextEditingController();
  var birthday = '';


  @override
  void dispose() {
    emailController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
              children: [
                SizedBox(height: 5.h,),
                RichText(
                  text: TextSpan(
                    children: const <TextSpan>[
                      TextSpan(text: 'Sing ',
                          style: TextStyle(color: Colors.white, fontSize: 50,)),
                      TextSpan(text: 'Up',
                          style: TextStyle(color: Colors.red, fontSize: 50,)),
                    ],
                  ),
                ),
                SizedBox(height: 2.h,),
                _emailTextField(),
                SizedBox(height: 2.h,),
                _passwordTextField(),
                SizedBox(height: 2.h,),
                _passwordConfirmTextField(),
                SizedBox(height: 2.h,),
                _userNameTextField(),
                SizedBox(height: 3.h,),
                RichText(
                  text: TextSpan(
                    children: const <TextSpan>[
                      TextSpan(text: 'Date de naissance ',
                          style: TextStyle(color: Colors.white, fontSize: 20,))
                    ],
                  ),
                ),
                SizedBox(height: 1.h,),
                SizedBox(
                  width: 100.w,
                  height: 10.h,
                  child: _agePickerWidget(),
                ),
                SizedBox(height: 5.h,),
                _bSignUp(),
                _bLogin()

              ]
          ),
        ),

      ),
    );
  }


  Widget _emailTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            child: TextFormField(
            style: TextStyle(
              color: Colors.white
              ),
              cursorColor: Colors.white,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                hintStyle: TextStyle(
                    color: Colors.white
                ),
                labelStyle: TextStyle(
                    color: Colors.white
                ),
                hintText: 'Exemple@gmail.com',
                labelText: 'Adresse Courrier',
              ),
              validator: (value){
                if(value != null && !value.contains(new RegExp(r'[@]')) | value.contains(new RegExp(r'[!#$%^&*(),?":{}|<>]'))
                | !value.endsWith('.com')) {
                  return 'Adresse Courrier invalide';
                }
              },
              onChanged: (value) {},
            ),
          );
        }
    );
  }

  Widget _passwordTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            child: TextFormField(
              style: TextStyle(
                color: Colors.white
              ),
              cursorColor: Colors.white,
              controller: passwordController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintText: 'Mot de Passe',
                labelText: 'Créer un mot de passe',
                hintStyle: TextStyle(
                    color: Colors.white
                ),
                labelStyle: TextStyle(
                    color: Colors.white
                ),
              ),

              onChanged: (value) {
              },
            ),
          );
        }
    );
  }

  Widget _passwordConfirmTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            child: TextFormField(
              style: TextStyle(
                  color: Colors.white
              ),
              cursorColor: Colors.white,
              controller: passwordConfirmController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintStyle: TextStyle(
                    color: Colors.white
                ),
                labelStyle: TextStyle(
                    color: Colors.white
                ),
                hintText: 'Mot de Passe',
                labelText: 'Confirmer votre mot de passe',
              ),
              validator: (value){
                if (passwordController.text.trim() != value){
                  return 'Le mot de passe ne correspond pas';
                }
              },
              onChanged: (value) {
              },
            ),
          );
        }
    );
  }

  Widget _userNameTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            child: TextFormField(
              style: TextStyle(
                  color: Colors.white
              ),
              cursorColor: Colors.white,
              controller: userNameController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintStyle: TextStyle(
                    color: Colors.white
                ),
                labelStyle: TextStyle(
                    color: Colors.white
                ),
                hintText: "Nom d'utilisateur",
                labelText: "Nouveau Nom D'utilisateur",
              ),
              onChanged: (value) {},
            ),
          );
        }
    );
  }

  Widget _agePickerWidget() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.white.withOpacity(0.9),
            ),
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              use24hFormat: true,
              minimumYear: 1922,
              onDateTimeChanged: (DateTime newDate) {
                birthday = newDate.year.toString()+'/'+newDate.month.toString()+'/'+newDate.day.toString();
              },
            ),
          );
        }
    );
  }

  Widget _bSignUp() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ElevatedButton(
            onPressed: signUp,
            style: ButtonStyle(
              backgroundColor:MaterialStateProperty.all<Color>(Color(
                  0xF5FF0000).withOpacity(0.9)),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.0),
              child: Text('Sign Up',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                  )),
            ),

          );
        }
    );
  }

  Widget _bLogin() {
    return Container(
      child: StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Row(
            children: <Widget>[
              const Text("Avez-vous déjà un compte ?", style: TextStyle(color: Colors.white),),
              TextButton(
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 25,color: Color(
                      0xF5FF0000)),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'myApp');
                },
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          );
        }
    ),
    );
  }

  Future signUp() async{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
    final docUser = FirebaseFirestore.instance.collection('users').doc(emailController.text.trim());
    final json = {
    'Username' : userNameController.text.trim(),
    'birthday' : birthday,
    };
    await docUser.set(json);
    Navigator.pushNamed(context, 'myApp');
  }
}
