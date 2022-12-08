import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nest_music/pages/song.dart';
import 'package:provider/provider.dart';

import '../globalState/current_song_state.dart';

class MusicList extends StatefulWidget {
  const MusicList({Key? key}) : super(key: key);

  @override
  State<MusicList> createState() {
    return _MusicListState();
  }
}

class _MusicListState extends State<MusicList> {
  final db = FirebaseFirestore.instance;
  var isPlaying = false;
  


  @override
  Widget build(BuildContext context) {
    context.read<CurrentSongState>().setNewPlaylist();
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: db.collection('songs').snapshots(),
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
                Row(children: [
                  Spacer(),
                  Text("Songs",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),),
                  Icon(Icons.music_note_sharp,color: Colors.white,),
                  Spacer(),
                ]),
                SizedBox(
                  height: 25,
                ),SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: snapshot.data!.docs.map((doc) {
                          context.read<CurrentSongState>().addSongToPlylist(doc.get('title')+'/'+doc.get('artist')+'/'+doc.get('album')+'/'+doc.get('duration'));
                          context.read<CurrentSongState>().addAllSongToPlylist(doc.get('title')+'/'+doc.get('artist')+'/'+doc.get('album')+'/'+doc.get('duration'));
                          if(!doc.get('newInNest')){
                            return Song(title: doc.get('title'), artist: doc.get('artist'),duration: doc.get('duration'),image: doc.get('album'),);
                          }
                          return Container();
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
