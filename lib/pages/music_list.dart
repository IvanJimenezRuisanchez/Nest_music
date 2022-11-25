import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nest_music/pages/icon_widget.dart';

class MusicList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text("Recommandations",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
            ),),
          SizedBox(
            height: 10,
          ),
          for(int i = 1; i < 20; i++)
          Container(
            margin: EdgeInsets.only(top: 15,right: 12,left: 5),
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            decoration: BoxDecoration(
              color: Color(0xFF30314D).withOpacity(0.5),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Text(i.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  ),),
                SizedBox(width: 25,),
                InkWell(
                  onTap: (){},
                  child :Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hit 'Em Up - Single Version",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    ),),
                    Row(
                      children: [
                        Text('2Pac',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                          ),),
                        SizedBox(width: 5),
                      ],
                    )
                  ],
                )
                ),
                Spacer(),
                Container(
                  child: TextButton(
                    child:  IconWidget(icon: Icons.play_arrow,color: Colors.black12,), onPressed: () {  },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
