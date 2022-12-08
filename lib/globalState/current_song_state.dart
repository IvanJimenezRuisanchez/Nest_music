import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:nest_music/pages/music_player_bottom.dart';

import '../pages/song.dart';

class CurrentSongState with ChangeNotifier{
  final db = FirebaseFirestore.instance;
  final email = FirebaseAuth.instance.currentUser?.email;
  String currentSong = '';
  String get getSong => currentSong;
  bool playing = false;
  bool get getPlaying => playing;
  List songsPlayList = [];
  List myFavorites = [];
  List get getFavorites => myFavorites;
  List get getCurrentPlaylist => songsPlayList;
  List allSongs = [];

  MusicPlayerBottom musicPlayerBottom = MusicPlayerBottom(song_to_play: '');
  MusicPlayerBottom get getMusicPlayer => musicPlayerBottom;

  void addAllSongToPlylist(song){
    allSongs.add(song);
  }
  void setPlaying(value){
    playing = value;
    notifyListeners();
  }

  void setSong(song){
    currentSong = song;
    notifyListeners();
  }

  void setFavorites(favorites){
    myFavorites = favorites;
  }

  void setNewPlaylist(){
    songsPlayList = [];
  }

  void setMusicPlayer(song){
    musicPlayerBottom = MusicPlayerBottom(song_to_play: song,key: UniqueKey(),);
    notifyListeners();
  }

  void addSongToPlylist(song){
    songsPlayList.add(song);
  }

  Future<void> addToMyFavorites() async {
    if (!myFavorites.contains(currentSong+';')) {
        final playListDb = FirebaseFirestore.instance.collection('playlists').doc(
            FirebaseAuth.instance.currentUser?.email);
        myFavorites.add(currentSong+';');
        final json = {
          'myFavs': myFavorites
        };
        await playListDb.set(json);
        notifyListeners();
    }
  }

  Future<void> removeFromMyFavorites() async {
    int index = myFavorites.indexOf(currentSong+';');
    print(myFavorites[index]);
    myFavorites.removeAt(index);
    if (myFavorites.isEmpty){
      final playListDb= FirebaseFirestore.instance.collection('playlists').doc(FirebaseAuth.instance.currentUser?.email);
      playListDb.delete();
    }
    else {
      final playListDb = FirebaseFirestore.instance.collection('playlists').doc(
          FirebaseAuth.instance.currentUser?.email);
      final json = {
        'myFavs': myFavorites,
      };
      await playListDb.update(json);
      notifyListeners();
    }
  }

  void setNextSong(){
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
    int previous;
    if (songsPlayList.indexOf(currentSong) == 0){
      previous =  songsPlayList.length;
    }else{
      previous = songsPlayList.indexOf(currentSong);
    }
    currentSong = songsPlayList[previous-1];
    musicPlayerBottom = MusicPlayerBottom(song_to_play: currentSong,key: UniqueKey());
    notifyListeners();
  }

  bool checkFavorite(song){
    if (myFavorites.contains(song+';')){
      return true;
    }
    return false;
  }

  List getSongsByNameArtistOrTitle(value){
    List songsFilter = [];
    var i = 0;
    while (i < allSongs.length){
      List song = allSongs[i].toString().split('/');
      var e = 0;
      while (e < song.length) {
        if (song[e].toString().trim().toLowerCase().contains(value.toString().trim().toLowerCase())){
          if(!songsFilter.contains(allSongs[i].toString())) {
            songsFilter.add(allSongs[i].toString());
            break;
          }
        }
        e++;
      }
      i++;
    }
    return songsFilter;
  }
}