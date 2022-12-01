import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nest_music/pages/icon_widget.dart';
import 'package:nest_music/pages/song.dart';

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
                Text("Recommandations",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),),
                SizedBox(
                  height: 25,
                ),SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: snapshot.data!.docs.map((doc) {
                          return Song(title: doc.get('title'), id: doc.id, artist: doc.get('artist'),duration: doc.get('duration'),image: doc.get('album'),);
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
