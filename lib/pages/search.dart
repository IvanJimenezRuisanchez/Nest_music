import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nest_music/pages/song.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../globalState/current_song_state.dart';

class Search extends StatefulWidget {
  const Search( {Key? key ,required this.value}) : super(key: key);
  final value;
  @override
  State<Search> createState() {
    return _SearchState();
  }
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    var results = context.read<CurrentSongState>().getSongsByNameArtistOrTitle(widget.value);
    context.read<CurrentSongState>().setNewPlaylist();
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [Spacer(),
              SizedBox(height: 10.h,),
            Text("Results",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),),
            Icon(Icons.security_sharp,color: Colors.white,),
            SizedBox(height: 10.h,),
            Spacer(),],
          ),
          Column(
            children: List.generate(results.length, (index){
              var song = results[index].toString().split('/');
              context.read<CurrentSongState>().addSongToPlylist(song[0]+'/'+song[1]+'/'+song[2]+'/'+song[3]);

              return Song(title: song[0], artist: song[1], duration: song[3], image: song[2]);
            }),
          )

        ],
      )
    );
  }
}
