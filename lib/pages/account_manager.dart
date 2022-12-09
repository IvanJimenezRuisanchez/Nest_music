import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:nest_music/main.dart';
import 'package:nest_music/services/firebase_storage_service.dart';
import 'icon_widget.dart';

class AccountManager extends StatefulWidget {
  static String id = 'account_manager';
  @override
  State<AccountManager> createState() => _AccountManagerState();
}

class _AccountManagerState extends State<AccountManager> {
  var user;
  var show;
  var changeInputEmail;
  final emailController = TextEditingController();

  @override
  void initState() {
    changeInputEmail = true;
    user = FirebaseAuth.instance.currentUser!;
    show = false;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withAlpha(10),
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(65.0),
            child:  AppBar(
              toolbarHeight: 120.0,
              backgroundColor: Color(0xFF31314F).withOpacity(0.5),
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
        color: Color(0xFF31314F).withOpacity(0.5),
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
                Navigator.of(context).pushNamedAndRemoveUntil('myApp', (Route route) => false);
              },
            )
          ],
        )
    );
  }
  Widget deleteAccount(){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Color(0xFF31314F).withOpacity(0.5),
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
        color: Color(0xFF31314F).withOpacity(0.5),
        elevation: 10,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: IconWidget(icon: Icons.lock,color: Colors.transparent,),
              title: Text('Changer mot de Passe',style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),),
              onTap: (){
                FirebaseAuth.instance.sendPasswordResetEmail(email: user.email);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Un e-mail a été envoyé pour changer le mot de passe"),
                    action: SnackBarAction(
                      label: 'Action',
                      textColor: Colors.blueAccent,
                      onPressed: () {
                        // Code to execute.
                      },
                    ),
                  ),
                );
              },
            )
          ],
        )
    );
  }

  Widget changeEmail(){
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Color(0xFF31314F).withOpacity(0.5),
        elevation: 10,
        child: Column(
          children: <Widget>[
            changeInputEmail ?
                Column(children: [
                  ListTile(
                    title: Text('Current email',style : TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),),
                  ),
                  ListTile(
                    leading: IconWidget(icon: Icons.email,color: Colors.transparent,),
                    title: Text(user.email,style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),),
                    onTap: (){
                      setState(() {
                        changeInputEmail = false;
                      });
                    },
                  )
                ],)
                : Container(
                    padding: EdgeInsets.all(15),
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
                      hintText: 'Nouveau E-mail',
                      labelText: 'E-mail',
                      hintStyle: TextStyle(
                      color: Colors.white
                      ),
                      labelStyle: TextStyle(
                      color: Colors.white
                      ),
                    ),
                      validator: (value){
                        if(value != null && !value.contains(new RegExp(r'[@]')) | value.contains(new RegExp(r'[!#$%^&*(),?":{}|<>]'))
                        ) {
                          return 'Adresse Courrier invalide';
                        }
                      },
                      onFieldSubmitted: (value){
                        /*
                        FirebaseAuth.instance.currentUser?.updateEmail(emailController.text.toString().trim());
                        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.email).delete();
                        final docUser = FirebaseFirestore.instance.collection('users').doc(emailController.text.trim());
                        setState(() {
                          changeInputEmail = true;
                          user = FirebaseAuth.instance.currentUser;
                        });
                        Navigator.of(context).pushNamedAndRemoveUntil('myApp', (Route route) => false);*/
                      },
                  )
            )
    ],)
    );
  }

  Widget showDialogAlert(){
   return AlertDialog(
      title: Text('Supprimer le compte'),
      content: const Text('Êtes-vous sûr de vouloir supprimer votre compte ?'),
      actions: [
        TextButton(
          onPressed: () {
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
            Navigator.of(context).pushNamedAndRemoveUntil('myApp', (Route route) => false);
          },
          child: const Text('YES'),

        ),
      ],
    );
  }

  void updateEmail(value){
    FirebaseAuth.instance.currentUser?.updateEmail(value);
  }

}
  
