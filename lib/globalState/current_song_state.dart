import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:nest_music/pages/music_player_bottom.dart';

class CurrentSongState with ChangeNotifier{
  String currentSong = '';
  String get getSong => currentSong;
  bool playing = false;
  bool get getPlaying => playing;
  List songsPlayList = [];
  List myFavorites = [];

  MusicPlayerBottom musicPlayerBottom = MusicPlayerBottom(song_to_play: '');
  MusicPlayerBottom get getMusicPlayer => musicPlayerBottom;

  void setPlaying(value){
    playing = value;
    notifyListeners();
  }

  void setSong(song){
    currentSong = song;
    notifyListeners();
  }

  void setMusicPlayer(song){
    print(songsPlayList);
    musicPlayerBottom = MusicPlayerBottom(song_to_play: song,key: UniqueKey(),);
    notifyListeners();
  }

  void addSongToPlylist(song){
    songsPlayList.add(song);
    print(myFavorites);
    notifyListeners();
  }

  void addToMyFavorites(){
    myFavorites.add(currentSong);
    print(myFavorites);
    notifyListeners();
  }

  void removeFromMyFavorites(){
    int index = myFavorites.indexOf(currentSong);
    myFavorites.removeAt(index);
    print(myFavorites);
    notifyListeners();
  }
  void setNextSong(){
    playing = true;
    int nextSong;
    if (songsPlayList.indexOf(currentSong) == songsPlayList.length-1){
      nextSong = -1;
    }else{
      nextSong = songsPlayList.indexOf(currentSong);
    }
    currentSong = songsPlayList[nextSong+1];
    musicPlayerBottom = MusicPlayerBottom(song_to_play: currentSong,key: UniqueKey());
    notifyListeners();
  }

  void setPreviousSong(){
    playing = true;
    int nextSong;
    if (songsPlayList.indexOf(currentSong) == 0){
      nextSong =  songsPlayList.length-1;
    }else{
      nextSong = songsPlayList.indexOf(currentSong)-1;
    }
    currentSong = songsPlayList[nextSong];
    musicPlayerBottom = MusicPlayerBottom(song_to_play: currentSong,key: UniqueKey());
    notifyListeners();
  }
}