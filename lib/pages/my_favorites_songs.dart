import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nest_music/globalState/current_song_state.dart';
import 'package:nest_music/pages/song.dart';
import 'package:provider/provider.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({Key? key}) : super(key: key);

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {
  @override
  Widget build(BuildContext context) {
    var myFav = context.watch<CurrentSongState>().getMyFav;

    return SingleChildScrollView(
      child: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 25),
                  Container(
                  child: Container(
                    child: Column(
                      children: List.generate(myFav.length, (index) {
                        var song = myFav[index].split('/');
                        print(song);
                        return Song(title: song[0] , artist: song[1], duration: song[3], image: song[2]);
                      }),
                    ),
                  )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
