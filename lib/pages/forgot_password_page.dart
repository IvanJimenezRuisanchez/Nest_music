
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.0),
              RichText(
                text: TextSpan(
                  children: const <TextSpan>[
                    TextSpan(text: "Entrez l'adresse courrier associe a votre compte", style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              _userTextField(),
              SizedBox(height: 20,),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton.icon(
                    icon: Icon(Icons.email),
                    label: Text(
                  'Réinitialiser votre mot de passe', style: TextStyle(fontSize: 16),
                ),
                onPressed: (){
                      verifierEmail();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('E-mail de réinitialisation du mot de passe envoyé'),
                            action: SnackBarAction(
                              label: 'Action',
                              onPressed: () {
                                // Code to execute.
                              },
                            ),
                          ),
                        );
                },
              )
              ),
            Row(
              children: <Widget>[
                const Text("Retour au Log In"),
                TextButton(
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontSize: 20),
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
              controller: emailController,
              decoration: InputDecoration(
                  icon: Icon(Icons.email),
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
          email: 'ivanjr1802@gmail.com');
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

