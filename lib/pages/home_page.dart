import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  static String id = 'home_page';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child:  AppBar(
            toolbarHeight: 120.0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Bienvenue',
              style: TextStyle(fontFamily: 'Lobster-Regular', fontSize: 50,color: Colors.white),
            ),

            actions: [
              userInterface(),
              SizedBox(width: 20,)
            ],
          )),
          body: Container(
            color: Colors.deepPurple[200],
          ),
        ),
    );
  }

  Widget userInterface(){
    return IconButton(
        icon: Icon(
        Icons.menu,
        color: Colors.white,
          size: 35,
    ),
    onPressed: () {
      Navigator.pushNamed(context, 'account_manager');
    },
    );
  }
}
