import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nest_music/pages/forgot_password_page.dart';
import 'package:nest_music/pages/home_page.dart';
import 'package:nest_music/pages/login_page.dart';
import 'package:nest_music/pages/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot) {
            if (snapshot.hasData) {
              return Homepage();
            }
            else {
              return LoginPage();
            }
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        ForgotPasswordPage.id: (context) => ForgotPasswordPage(),
        LoginPage.id: (context) => LoginPage(),
        SignUp.id: (context) => SignUp(),
        Homepage.id: (context) => Homepage()
      },

    );
  }

}
