import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nest_music/main.dart';

class SignUp extends StatefulWidget {
  static String id = 'sign_up';

  @override
  _SignUpState createState() => _SignUpState();
}



class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final emailConfirmController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  var birthday = '';


  @override
  void dispose() {
    emailController.dispose();
    emailConfirmController.dispose();
    userNameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
              children: [
                SizedBox(height: 60,),
                RichText(
                  text: TextSpan(
                    children: const <TextSpan>[
                      TextSpan(text: 'Sing ',
                          style: TextStyle(color: Colors.black, fontSize: 50,)),
                      TextSpan(text: 'Up',
                          style: TextStyle(color: Colors.red, fontSize: 50,)),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                _emailTextField(),
                SizedBox(height: 30,),
                _emailConfirmTextField(),
                SizedBox(height: 30,),
                _passwordTextField(),
                SizedBox(height: 30,),
                _userNameTextField(),
                SizedBox(height: 30,),
                RichText(
                  text: TextSpan(
                    children: const <TextSpan>[
                      TextSpan(text: 'Date de naissance ',
                          style: TextStyle(color: Colors.black, fontSize: 20,))
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  width: 400.0,
                  height: 100.0,
                  child: _agePickerWidget(),
                ),
                SizedBox(height: 10,),
                _bSignUp(),
                _bLogin()

              ]
          ),
        ),

      ),
    );
  }

  Widget _emailConfirmTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            child: TextFormField(
              controller: emailConfirmController,
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Exemple@gmail.com',
                  labelText: 'Confirmer Votre Courrier'
              ),
              validator: (value){
                if(value != emailController.text.trim) {
                  return "L'adresse e-mail n'est pas la même";
                }
              },
              onChanged: (value) {},
            ),
          );
        }
    );
  }

  Widget _emailTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            child: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Exemple@gmail.com',
                  labelText: 'Adresse Courrier'
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
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Mot de Passe',
                labelText: 'Créer un mot de passe',
              ),
              onChanged: (value) {},
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
              controller: userNameController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
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
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              use24hFormat: true,
              minimumYear: 2004,
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
          return RaisedButton(
            onPressed: signUp,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 150.0, vertical: 15.0),
              child: Text('Sign Up',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                  )),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            elevation: 10.0,
            color: Colors.redAccent,

          );
        }
    );
  }

  Widget _bLogin() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Row(
            children: <Widget>[
              const Text("Avez-vous déjà un compte ?"),
              TextButton(
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'myApp');
                },
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          );
        }
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
