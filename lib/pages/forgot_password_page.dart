
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordPage extends StatefulWidget {
  static String id = 'forgot_password';


  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();

}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.h),
              SizedBox(
                width: 80.w,
                child: Text("Entrez l'adresse courrier associe a votre compte", style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 2.h,),
              _userTextField(),
              SizedBox(height: 4.h,),
              SizedBox(
                width: 95.w,
                child:  ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:MaterialStateProperty.all<Color>(Color(
                        0xF5FF0000).withOpacity(0.9)),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.h),
                    child: Text('RĂ©initialiser votre mot de passe',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0
                        )),
                  ),
                  onPressed: (){
                    verifierEmail();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('E-mail de rĂ©initialisation du mot de passe envoyĂ©'),
                        action: SnackBarAction(
                          label: 'Action',
                          onPressed: () {
                            // Code to execute.
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            Row(
              children: <Widget>[
                const Text("Retour au Log In",style: TextStyle(
                  color: Colors.white
                ),),
                TextButton(
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontSize: 20,color: Color(
                        0xF5FF0000)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, 'login_page');
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )
          ]
          ),
        ),
      ),
    );
  }

  Widget _userTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              style: TextStyle(
                  color: Colors.white
              ),
              cursorColor: Colors.white,
              controller: emailController,
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
                  icon: Icon(Icons.email,color: Colors.white),
                  hintText: 'Exemple@gmail.com',
                  labelText: 'Adresse Courrier'
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
              },
              validator: (value){
                if(value != null && !value.contains(new RegExp(r'[@]')) | value.contains(new RegExp(r'[!#$%^&*(),?":{}|<>]'))
                | !value.endsWith('.com')){
                return 'Adresse Courrier invalide';
                }
              },
            ),
          );
        }
    );
  }

  Future verifierEmail() async{
    showDialog(context: context, barrierDismissible: false, builder: (context) =>
    Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.toString());
      Navigator.pushNamed(context, 'login_page');
    } on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Une erreur est survenue'),
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
}

