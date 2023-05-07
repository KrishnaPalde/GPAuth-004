import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpauth_004/Models/gpauth_algorithms.dart';
import 'package:gpauth_004/Models/gpauth_encryption.dart';
import 'package:gpauth_004/Models/gpauth_user.dart';
import 'package:gpauth_004/Models/image_set.dart';

Future<Map<String, dynamic>> getGPAuthUserFromFirebase(String username) async {
  final data =
      await FirebaseFirestore.instance.collection('Users').doc(username).get();
  if (!data.exists) {
    return {'status': -1, 'data': null};
  } else {
    GPAuthUser _user = GPAuthUser.fromJson(data.data() as Map<String, dynamic>);

    return {'status': 1, 'data': _user};
  }
}

Future<Map<String, dynamic>> getImageSetDataFromFirebase(
    String imagesetName) async {
  print(imagesetName);
  final data = await FirebaseFirestore.instance
      .collection('GPAuth')
      .doc(imagesetName)
      .get();
  if (!data.exists) {
    return {'status': -1, 'data': null};
  } else {
    // print(data.data() as Map<String, dynamic>);
    ImageSet imageSetObject =
        ImageSet.fromJson(data.data() as Map<String, dynamic>);
    GPAuthAlgorithms.updateAllImageSet(imageSetObject);
    return {
      'status': 1,
      'data': imageSetObject,
    };
  }
}
