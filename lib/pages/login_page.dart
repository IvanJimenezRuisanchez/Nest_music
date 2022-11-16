import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              RichText(
                text: TextSpan(
                  children: const <TextSpan>[
                    TextSpan(text: 'Nest ', style: TextStyle(color: Colors.black,fontSize: 50,)),
                    TextSpan(text: 'Music', style: TextStyle(color: Colors.red,fontSize: 50,)),
                  ],
                ),
              ),
              Image.asset('images/AppLogo.png',
                height: 400.0,),
              SizedBox(height: 15.0),
              _userTextField(),
              SizedBox(height: 15.0),
              _passwordTextField(),
              SizedBox(height: 15.0),
              _forgotPassword(),
              _bLogin(),
              _bSignUp()

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
            child: TextField(
              decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Exemple@gmail.com',
                  labelText: 'Adresse Courrier'
              ),
              onChanged: (value) {

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
            child: TextField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: 'Mot de Passe',
                  labelText: 'Votre Mot de Passe',
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
          return RaisedButton(
            onPressed: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 150.0, vertical: 15.0),
              child: Text('Login',
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

  Widget _bSignUp() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Row(
            children: <Widget>[
              const Text("Vous n'avez pas de compte ?"),
              TextButton(
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 20),
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
              //forgot password screen
            },
            child: const Text('Forgot Password',),
          );
        }
    );
  }
}
