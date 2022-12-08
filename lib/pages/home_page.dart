
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nest_music/globalState/current_song_state.dart';
import 'package:nest_music/pages/music_player_bottom.dart';
import 'package:nest_music/pages/my_favorites_songs.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';


import 'music_list.dart';

class Homepage extends StatefulWidget {
  static String id = 'home_page';
  @override
  State<Homepage> createState() => _HomepageState();
}



class _HomepageState extends State<Homepage> {
  final db = FirebaseFirestore.instance;
  final email = FirebaseAuth.instance.currentUser?.email;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var show = context.watch<CurrentSongState>().playing;
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child:  AppBar(
            toolbarHeight: 120.0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Nest Music',
              style: TextStyle(fontFamily: 'Lobster-Regular', fontSize: 50,color: Colors.white),
            ),
            actions: [
              userInterface(),
              SizedBox(width: 20,)
            ],
          )),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: 2.h,
                left: 1.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Padding(padding: EdgeInsets.only(bottom: 5),
                    child: DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.white
                    ),
                    child: AnimatedTextKit(
                    animatedTexts: [
                    WavyAnimatedText('Bonjour'),
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,
                    pause: Duration(seconds: 5),))),
                  Padding(padding: EdgeInsets.only(bottom: 5),
                    child: Text('Bienvenue sur Nest Music',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),),),
                  Padding(
                    padding: EdgeInsets.only(top: 15,right: 20,bottom: 20),
                    child: Container(
                      height: 50,
                      width: 380,
                      decoration: BoxDecoration(
                        color: Color(0xFF31314F).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                           margin: EdgeInsets.symmetric(horizontal: 15),
                            height: 50,
                            width: 200,
                            child: TextFormField(
                              cursorColor: Colors.white,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Rechercher de la musique',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                border: InputBorder.none
                              ),
                            ),
                            ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.white,
                          ),)
                        ],
                      ),
                    ),
                  ),
                  TabBar(
                    isScrollable: true,
                    labelStyle: TextStyle(
                      fontSize: 18
                    ),
                    indicator: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 3,
                          color: Colors.teal
                        ),
                      )
                    ),
                    tabs: [
                      Tab(text: 'Chansons',),
                      Tab(text: 'Mes listes de lecture',),
                      Tab(text: 'Mes favoris',),
                      Tab(text: 'Nouveautés',),
                    ],
                  ),
                      Flexible(
                        flex: 1,
                        child: TabBarView(
                          children: [
                            MusicList(),
                            Container(
                              color: Color(0xFF31314F).withOpacity(0.5),
                            ),
                            MyFavorites(),
                            Container(
                              color: Color(0xFF31314F).withOpacity(0.5),
                            ),
                          ],
                        )),
              SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                    stream: db.collection('playlists').snapshots(),
                    builder: (context,snapshot){
                      if (!snapshot.hasData){
                        return Center();
                      }else{
                        return Container(
                            child: Column(
                                children: [
                                 SingleChildScrollView(
                                    child: Container(
                                      child: Column(
                                        children: snapshot.data!.docs.map((doc) {
                                          List dbFavs = doc.get('myFavs').toString().split(';,');
                                            print(dbFavs);
                                            var i = 0;
                                            while (i < dbFavs.length) {
                                              if (i == 0) {
                                                if (dbFavs.length == 1) {
                                                  dbFavs[0] = dbFavs[0]
                                                      .toString()
                                                      .substring(0, dbFavs[0]
                                                      .toString()
                                                      .length - 2);
                                                }
                                                dbFavs[0] = dbFavs[0]
                                                    .toString()
                                                    .substring(1, dbFavs[0]
                                                    .toString()
                                                    .length) + ';';
                                              } else {
                                                if (i == dbFavs.length - 1) {
                                                  dbFavs[i] = dbFavs[i]
                                                      .toString()
                                                      .substring(1, dbFavs[i]
                                                      .toString()
                                                      .length - 2) + ';';
                                                }
                                                else {
                                                  dbFavs[i] = dbFavs[i]
                                                      .toString()
                                                      .substring(1, dbFavs[i]
                                                      .toString()
                                                      .length) + ';';
                                                }
                                              }
                                              i++;
                                            context.read<CurrentSongState>()
                                                .setFavorites(dbFavs);
                                          }
                                          return Column();
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ]));
                      }}),
              )
                ],
              ),
              ),
            ),
          bottomNavigationBar: show ? context.watch<CurrentSongState>().musicPlayerBottom : SizedBox(),
          )
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
