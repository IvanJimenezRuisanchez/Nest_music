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
}