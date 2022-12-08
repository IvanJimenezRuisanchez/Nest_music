import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

Reference get firebaseStorage => FirebaseStorage.instance.ref();
class FirebaseStorageService extends GetxService{
  Future<String> getImage(imgName) async {
      var urlRef = firebaseStorage.child('covers')
          .child('${imgName}.png');
      var imgUrl = await urlRef.getDownloadURL();
      return imgUrl;
  }

    Future<String> getSong(nameSong) async {
    var urlRef = firebaseStorage.child('songs')
        .child('${nameSong}.mp3');
    var songUrl = await urlRef.getDownloadURL();
    return songUrl;
  }

}