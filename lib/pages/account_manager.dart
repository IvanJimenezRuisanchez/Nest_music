import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'icon_widget.dart';

class AccountManager extends StatefulWidget {
  static String id = 'account_manager';
  @override
  State<AccountManager> createState() => _AccountManagerState();
}

class _AccountManagerState extends State<AccountManager> {
  final user = FirebaseAuth.instance.currentUser!;
  var show;

  @override
  void initState() {
    show = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple[200],
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(65.0),
            child:  AppBar(
              toolbarHeight: 120.0,
              backgroundColor: Colors.deepPurple[300],
              elevation: 3,
              centerTitle: true,
              title: Text(
                'Configuration',
                style: TextStyle(fontFamily: 'Lobster-Regular', fontSize: 40,color: Colors.white),
              ),
            )),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text('Settings',style: TextStyle(
                color: Colors.white,
                fontSize: 25,

              ),),
              changeEmail(),
              changePassword(),
              langue(),
              logOut(),
              show ? showDialogAlert() : deleteAccount()

            ],
          ),
        ),
        );
  }

  Widget returnButton(){
    return IconButton(
        icon: Icon(Icons.arrow_back_rounded,
        color: Colors.white,
        size: 25,
    ), onPressed: () {
          Navigator.pushNamed(context, 'home_page');
    },
    );
  }

  Widget logOut(){
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Colors.deepPurple[200],
        elevation: 10,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: IconWidget(icon: Icons.logout,color: Colors.blueAccent,),
              title: Text('Logout',style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),),
              onTap: (){
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, 'myApp');
              },
            )
          ],
        )
    );
  }
  Widget deleteAccount(){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.deepPurple[200],
      elevation: 10,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: IconWidget(icon: Icons.delete,color: Colors.redAccent,),
            title: Text('Suprimer votre copmte',style: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),),
            onTap: (){
              setState(() {
                show = true;
              });
            },
          ),

        ],
      )
    );
  }

  Widget changePassword(){
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Colors.deepPurple[200],
        elevation: 10,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: IconWidget(icon: Icons.lock,color: Colors.transparent,),
              title: Text('Changer mot de Passe',style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),),
              onTap: (){},
            )
          ],
        )
    );
  }

  Widget changeEmail(){
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Colors.deepPurple[200],
        elevation: 10,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: IconWidget(icon: Icons.email,color: Colors.transparent,),
              title: Text('Changer E-mail',style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),),
              onTap: (){},
            )
          ],
        )
    );
  }

  Widget langue(){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.deepPurple[200],
      elevation: 10,
      child: Column(
        children: <Widget>[
        ],
      ),
    );
  }

  Widget showDialogAlert(){
   return AlertDialog(
      title: Text('Supprimer le compte'),
      content: const Text('Êtes-vous sûr de vouloir supprimer votre compte ?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'account_manager');
            setState(() {
              show = false;
            });
          },
          child: const Text('NO'),
        ),
        TextButton(
          onPressed: (){
            FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.email!)
                .delete();
            FirebaseAuth.instance.signOut();
            FirebaseAuth.instance.currentUser?.delete();
            Navigator.pushNamed(context, 'myApp');
          },
          child: const Text('YES'),

        ),
      ],
    );
  }




}
  
