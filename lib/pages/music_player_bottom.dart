import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:marquee/marquee.dart';

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
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  @override
  void initState() {
    isPLaying = true;
    isRepeat = false;

    audioPLayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPLaying = event == PlayerState.playing;
      });
    });

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
    super.initState();
  }

  @override
   Widget build(BuildContext context){
    return BottomAppBar(
      color: Colors.black54,
        elevation:1,
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
                          future: firebaseStorageService.getImage('Un Verano Sin Ti'),
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
                    SizedBox(width: 20),
                    InkWell(
                      child :Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildAnimatedTitle('Moscow Mule'),
                          Row(
                            children: [
                              buildAnimatedArtist('Bad Bunny')
                            ],
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){}
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
                          var url = await firebaseStorageService.getSong('Bad Bunny-Moscow Mule');
                          print(url);
                          await audioPLayer.play(UrlSource(url));
                        }
                        , icon: Icon(Icons.play_circle_filled_outlined,color: Colors.white,size: 50,)),
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){}
                        , icon: Icon(Icons.skip_next_rounded,color: Colors.white.withOpacity(0.8),size: 30,)
                    ),
                    isRepeat ? IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          setState(() {
                            isRepeat = false;
                          });
                        }
                        , icon: Icon(Icons.repeat,color: Colors.teal ,size: 25,)
                    )
                    : IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){
                          setState(() {
                            isRepeat = true;
                          });
                        }
                        , icon: Icon(Icons.repeat,color: Colors.white.withOpacity(0.8),size: 25,)
                    ),
                    SizedBox(width: 10,),
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

  Widget buildAnimatedTitle(String text) => Container(
      height: 20,
      width: 140,
      child: Marquee(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        blankSpace: 50,
        velocity: 50,
        pauseAfterRound: Duration(seconds: 5),)
  );

  Widget buildAnimatedArtist(String text) => Container(
      height: 20,
      width: 140,
      child: Marquee(
        text: text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 15,
          ),
        blankSpace: 100,
        velocity: 50,
        pauseAfterRound: Duration(seconds: 15),)
  );

}
