import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  static String id = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var _isHidden;

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _isHidden = false;
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
            children: [
              RichText(
                text: TextSpan(
                  children: const <TextSpan>[
                    TextSpan(text: 'Nest ', style: TextStyle(color: Colors.white,fontSize: 50,)),
                    TextSpan(text: 'Music', style: TextStyle(color: Color(
                        0xF5FF0000),fontSize: 50,)),
                  ],
                ),
              ),
              Image.asset('assets/images/AppLogo.png',
                height: 390.0,),
              SizedBox(height: 15.0),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white.withOpacity(0.1),
                ),
                child: Column(
                  children: [
                    _userTextField(),
                    SizedBox(height: 5.0),
                    _passwordTextField(),
                  ],
                ),
              ),
              _forgotPassword(),
              _bLogin(),
              _bSignUp(),
            ],
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

              controller: emailController,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                  icon: Icon(Icons.email,color: Colors.white),
                  hintText: 'Exemple@gmail.com',
                  hintStyle: TextStyle(
                    color: Colors.white
                  ),
                  labelText: 'Adresse Courrier',
                  labelStyle: TextStyle(
                  color: Colors.white
              ),
              ),
              onChanged: (value) {
              },
              validator: (value){
                if(value != null && !value.contains(new RegExp(r'[@]')) | value.contains(new RegExp(r'[!#$%^&*(),?":{}|<>]'))
                | !value.endsWith('.com')) {
                  return 'Adresse Courrier invalide';
                }
              },
            ),
          );
        }
    );
  }

  Widget _passwordTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              style: TextStyle(
                  color: Colors.white
              ),
              cursorColor: Colors.white,
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _isHidden,
              decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  icon: Icon(Icons.lock,color: Colors.white,),
                  iconColor: Colors.white,
                  hintText: 'Mot de Passe',
                  labelText: 'Votre Mot de Passe',
                  hintStyle: TextStyle(
                      color: Colors.white
                  ),
                  labelStyle: TextStyle(
                      color: Colors.white
                  ),
                  suffix: InkWell(
                    onTap: _toggleMotPasse,
                    child: Icon(
                      _isHidden ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                  )
              ),
              onChanged: (value) {},
            ),
          );
        }
    );
  }

  Widget _bLogin() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ElevatedButton(
            onPressed: signIn,
            style: ButtonStyle(
              backgroundColor:MaterialStateProperty.all<Color>(Color(
              0xF5FF0000).withOpacity(0.9)),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 150.0, vertical: 15.0),
              child: Text('Login',
                style: TextStyle(
                fontSize: 20.0,
                  color: Colors.white,
              )),
            ),

          );

        }
    );
  }

  Widget _bSignUp() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Row(
            children: <Widget>[
              const Text("Vous n'avez pas de compte ?",style: TextStyle(color: Colors.white)),
              TextButton(
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 25,color: Color(
                      0xF5FF0000))
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'sign_up');
                },
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          );
        }
    );
  }


  Widget _forgotPassword() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'forgot_password');
              //forgot password screen
            },
            child: const Text('Mot de passe oublié ?',style: TextStyle(color: Colors.white)),
          );
        }
    );
  }

  Future signIn() async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Mauvais email ou mot de passe. Réessayer!'),
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

  Future _toggleMotPasse() async{
    setState(() {
      _isHidden = !_isHidden;
    });
    }
}
