import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nest_music/globalState/current_song_state.dart';
import 'package:nest_music/pages/song.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({Key? key}) : super(key: key);

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}


class _MyFavoritesState extends State<MyFavorites> {
  final db = FirebaseFirestore.instance;
  final email = FirebaseAuth.instance.currentUser?.email;
  @override
  Widget build(BuildContext context) {
    context.read<CurrentSongState>().setNewPlaylist();
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
          stream: db.collection('playlists').snapshots(),
          builder: (context,snapshot){
            if (!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else{
              return Container(
                  child: Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 90.w,
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 20,
                                  ),
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      TyperAnimatedText("Ajoutez des chansons à cette liste à l'aide de l'icône en forme de cœur!"),
                                      TyperAnimatedText('Profitez de vos chansons préférées!'),
                                    ],
                                    repeatForever: true,
                                    pause: Duration(seconds: 3),
                                  ),
                                ),
                              ),
                        ]),
                        SizedBox(
                          height: 25,
                        ),SingleChildScrollView(
                          child: Container(
                            child: Column(
                              children: snapshot.data!.docs.map((doc) {
                                List dbFavs = doc.get('myFavs').toString().split(';,');
                                  print(dbFavs);
                                  var i = 0;
                                  while (i < dbFavs.length) {
                                    if (i == 0) {
                                      if (dbFavs.length == 1) {
                                        dbFavs[0] =
                                            dbFavs[0].toString().substring(
                                                0, dbFavs[0]
                                                .toString()
                                                .length - 2);
                                      }
                                      dbFavs[0] =
                                          dbFavs[0].toString().substring(
                                              1, dbFavs[0]
                                              .toString()
                                              .length);
                                    } else {
                                      if (i == dbFavs.length - 1) {
                                        dbFavs[i] =
                                            dbFavs[i].toString().substring(
                                                1, dbFavs[i]
                                                .toString()
                                                .length - 2);
                                      }
                                      else {
                                        dbFavs[i] =
                                            dbFavs[i].toString().substring(
                                                1, dbFavs[i]
                                                .toString()
                                                .length);
                                      }
                                    }
                                    i++;
                                  }
                                return Column(
                                  children: List.generate(dbFavs.length, (index){
                                    var song = dbFavs[index].toString().split('/');
                                    context.read<CurrentSongState>().addSongToPlylist(song[0]+'/'+song[1]+'/'+song[2]+'/'+song[3]);
                                    return Song(title: song[0], artist: song[1], duration: song[3], image: song[2]);
                                  }),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,)
                      ]));
            }}),
    );
  }
}
