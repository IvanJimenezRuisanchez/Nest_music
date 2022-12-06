import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

import '../globalState/current_song_state.dart';
import '../services/firebase_storage_service.dart';

class MusicPlayerBottom extends StatefulWidget {
  final song_to_play;
  const MusicPlayerBottom({
    Key? key,
    required this.song_to_play
  }) : super(key: key);

  @override
  State<MusicPlayerBottom> createState() => _MusicPlayerBottomState();
}


class _MusicPlayerBottomState extends State<MusicPlayerBottom> {
  final audioPLayer = AudioPlayer();
  late FirebaseStorageService firebaseStorageService = Get.put(FirebaseStorageService());
  var isPLaying;
  var isRepeat;
  var isFavorite;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  @override
  void initState(){
    isPLaying = true;
    isRepeat = false;
    isFavorite = false;
    audioPLayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPLaying = event == PlayerState.playing;
      });
    });

    _asyncMethod() async {
      var details = widget.song_to_play.split('/');
      var url = await firebaseStorageService.getSong(details[1]+'-'+details[0]);
      await audioPLayer.play(UrlSource(url));
    }


    audioPLayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    audioPLayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });

    audioPLayer.onPlayerComplete.listen((event) {
      if (isRepeat == true) {
        _asyncMethod();
      }
      else{
        audioPLayer.stop();
        context.read<CurrentSongState>().setNextSong();
      }
    });

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _asyncMethod();
    });
  }

  @override
  void dispose() {
    audioPLayer.stop();
    super.dispose();
  }

  @override
   Widget build(BuildContext context){
    var song = context.watch<CurrentSongState>().currentSong.split('/');
    setState(() {
      isFavorite = context.watch<CurrentSongState>().checkFavorite(widget.song_to_play);
    });
    return BottomAppBar(
      color: Colors.black54,
        elevation:4,
        child: SizedBox(
          height: 100,
          child: InkWell(
            child: Column(
              children: [
                SizedBox(height: 10,),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Container(
                      height: 60,
                      width: 60,
                      child: FutureBuilder<String>(
                          future: firebaseStorageService.getImage('${song[2]}'),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Image(
                                  image: NetworkImage(snapshot.data.toString())
                              );
                            }
                            return CircularProgressIndicator();
                          }
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      child :Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildAnimatedTitle('${song[0]}'),
                          Row(
                            children: [
                              buildAnimatedArtist('${song[1]}')
                            ],
                          )
                        ],
                      ),
                    ),
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          Timer(Duration(milliseconds: 500), () { // <-- Delay here
                            context.read<CurrentSongState>().setPreviousSong(); // <-- Code run after delay
                          });
                        }
                        , icon: Icon(Icons.skip_previous,color: Colors.white.withOpacity(0.8),size: 30,)
                    ),
                    isPLaying ? IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          setState(() {
                            isPLaying = false;
                          });
                          await audioPLayer.pause();
                        }
                        , icon: Icon(Icons.pause_circle_filled_outlined,color: Colors.white,size: 50,)) : IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          setState(() {
                            isPLaying = true;
                          });
                          var url = await firebaseStorageService.getSong(song[1]+'-'+song[0]);
                          print(url);
                          await audioPLayer.play(UrlSource(url));
                        }
                        , icon: Icon(Icons.play_circle_filled_outlined,color: Colors.white,size: 50,)),
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          Timer(Duration(milliseconds: 500), () { // <-- Delay here
                            context.read<CurrentSongState>().setNextSong(); // <-- Code run after delay
                          });
                        }
                        , icon: Icon(Icons.skip_next_rounded,color: Colors.white.withOpacity(0.8),size: 30,)
                    ),
                    isRepeat ? IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () async {
                          setState(() {
                            isRepeat = false;
                          });
                        }
                        , icon: Icon(Icons.repeat_one,color: Colors.teal ,size: 25,)
                    )
                    : IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: (){
                          setState(() {
                            isRepeat = true;
                          });
                        }
                        , icon: Icon(Icons.repeat,color: Colors.white.withOpacity(0.8),size: 25,)
                    ),
                    SizedBox(width: 10,),
                    isFavorite ? IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () async {
                          setState(() {
                            isFavorite = false;
                            context.read<CurrentSongState>().removeFromMyFavorites();
                          });
                        }
                        , icon: Icon(Icons.favorite,color: Colors.redAccent,size: 25,)
                    ) : IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: (){
                          setState(() {
                            isFavorite = true;
                            context.read<CurrentSongState>().addToMyFavorites();
                          });
                        }
                        , icon: Icon(Icons.favorite_border,color: Colors.white,size: 25,)
                    ),
                  ]
                  ),
                  Row(
                          children: [
                            SizedBox(height: 30,),
                            Spacer(),
                            SizedBox(
                              width: 350,
                              child: ProgressBar(
                                timeLabelLocation: TimeLabelLocation.sides,
                                timeLabelTextStyle: TextStyle(
                                color: Colors.white
                                ),
                                progress: position,
                                total: duration,
                                progressBarColor: Colors.teal,
                                baseBarColor: Colors.white.withOpacity(0.24),
                                bufferedBarColor: Colors.white.withOpacity(0.24),
                                thumbColor: Colors.white,
                                barHeight: 7.0,
                                thumbRadius: 8.0,
                                onSeek: (duration) async {
                                  final position = Duration(seconds: duration.inSeconds);
                                  await audioPLayer.seek(position);
                              },
                            )
                            ),
                            Spacer(),
                          ],
                           ),
                    ],
                  )
              ),
            ),
          );
  }

  Widget buildAnimatedTitle(String text) => SizedBox(
      height: 20,
      width: 140,
      child: Marquee(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        velocity: 50,
        blankSpace: 100,
        pauseAfterRound: Duration(seconds: 3))
  );

  Widget buildAnimatedArtist(String text) => SizedBox(
      height: 20,
      width: 140,
      child: Marquee(
        text: text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 15,
          ),
      blankSpace: 100,
          pauseAfterRound: Duration(seconds: 5),
          startAfter: Duration(seconds: 5))
  );

}
