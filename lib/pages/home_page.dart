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
        resizeToAvoidBottomInset: false,
        body: Center(
        child: Column(
          children: [ 
            Text(user.email!),
            SizedBox(height: 40),
            ElevatedButton(onPressed: () => FirebaseAuth.instance.signOut(), child: Text('ss'))
          ]
        ),
      ),
    )
    );
  }
}
