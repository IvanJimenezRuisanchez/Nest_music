import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nest_music/services/firebase_storage_service.dart';

class Song extends StatefulWidget {
  final id;
  final title;
  final artist;
  final duration;
  final image;

  const Song({
    Key? key,
    required this.title,
    required this.id,
    required this.artist,
    required this.duration,
    required this.image
  }) : super(key: key);



  @override
  State<Song> createState() => _SongState();
}

class _SongState extends State<Song> {
  var isPlaying;
  var isFavorite;
  late FirebaseStorageService firebaseStorageService = Get.put(FirebaseStorageService());

  @override
  void initState() {
    isPlaying = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
      margin: EdgeInsets.only(right: 10,left: 5,bottom: 15),
      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
      decoration: BoxDecoration(
          color: Color(0xFF31314F).withOpacity(0.5),  //Color(0xFF30314D).withOpacity(0.5)
          borderRadius: BorderRadius.circular(10)
      ),
      child:
      Row(
        children: [
          Container(
            height: 50,
            width: 50,
          child: FutureBuilder<String>(
            future: firebaseStorageService.getImage(widget.image),
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
          SizedBox(width: 20,),
          InkWell(
              child :Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                    ),),
                  Row(
                    children: [
                      Text(widget.artist,
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 15,
                        ),)
                    ],
                  )
                ],
              ),
          ),
          Spacer(),
          Text(widget.duration,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),),
        ],
      ),
    ),

     onTap: (){
       setState(() {
         isPlaying = !isPlaying;
       });
     },
      onLongPress: (){
      },
    );
  }
}

