// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:math';

import 'package:gpauth_004/Models/database.dart';
import 'package:gpauth_004/Models/gpauth_encryption.dart';
import 'package:gpauth_004/Models/gpauth_user.dart';
import 'package:gpauth_004/Models/image_set.dart';

class GPAuthAlgorithms {
  static bool isMaliciousActivityDetected = false;
  static List<Map<String, dynamic>> selectedImages = [];
  static List<Map<String, dynamic>> allImageSet = [];
  static List<Map<String, dynamic>> currentImageSet = [];
  static List<Map<String, dynamic>> passwordImageSet = [];

  static void updateAllImageSet(ImageSet obj) {
    allImageSet.addAll(obj.imageSet);
    allImageSet.addAll(obj.imageSet1);
    allImageSet.addAll(obj.imageSet2);
    allImageSet.addAll(obj.imageSet3);
    allImageSet.addAll(obj.imageSet4);
    allImageSet.addAll(obj.extraImageSet); // Extra ImageSet
  }

  // Adds Particular Image to Selected Image Set from Current Image Set
  static void selectImageFromCurrentSet(int index) {
    selectedImages.add(currentImageSet[index]);
  }

  // Clear Selected Image Set
  static void removeAllSelectedImage() {
    selectedImages.clear();
  }

  // Function to populate Password Image Set
  // labels List must contain lowercase labels
  static void populatePasswordImageSet(List<String> labels) {
    allImageSet.forEach((element) {
      if (labels.contains(element['label'].toString().toLowerCase())) {
        passwordImageSet.add(element);
        allImageSet.remove(element);
      }
    });
  }

  // Function to Detect Malicious Activity on Currently Loaded Image Set
  static void detectMaliciousActivity() {}

  // Function to define which set contains Password Image
  static Map<String, dynamic> setPasswordImagesIndex() {
    if (isMaliciousActivityDetected) {
      Random r = Random();
      var isContainPassword = r.nextBool();
      if (isContainPassword) {
        List<Map<String, dynamic>> _temp = [];
        if (selectedImages.isNotEmpty) {
          passwordImageSet.forEach((element) {
            if (!selectedImages.contains(element)) {
              _temp.add(element);
            }
          });

          if (_temp.length == 1) {
            return {
              "isPasswordImage": true,
              "passwordImageElement": _temp.first,
            };
          } else if (_temp.length > 1) {
            _temp.shuffle();
            return {
              "isPasswordImage": true,
              "passwordImageElement": _temp.first,
            };
          } else {
            return {
              "isPasswordImage": false,
              "passwordImageElement": {},
            };
          }
        } else {
          int a = r.nextInt(101);
          bool b = r.nextBool();
          if (a.isEven) {
            if (b) {
              passwordImageSet.shuffle();
            }
            return {
              "isPasswordImage": b,
              "passwordImageElement": b ? passwordImageSet.first : {},
            };
          } else {
            if (!b) {
              passwordImageSet.shuffle();
            }
            return {
              "isPasswordImage": !b,
              "passwordImageElement": !b ? passwordImageSet.first : {},
            };
          }
        }
      } else {
        return {
          "isPasswordImage": false,
          "passwordImageElement": {},
        };
      }
    } else {
      currentImageSet.addAll(passwordImageSet);
      return {};
    }
  }

  static List<Map<String, dynamic>> getFirstImageSet() {
    setPasswordImagesIndex();
    allImageSet.removeWhere((element) => passwordImageSet.contains(element));
    allImageSet.shuffle();
    currentImageSet
        .addAll(allImageSet.sublist(0, (9 - currentImageSet.length)));
    currentImageSet.shuffle();
    return currentImageSet;
  }

  // Function to return Set of 9 Images excluding current images
  // Pending
  static List<Map<String, dynamic>> getRandomImageSetExceptCurrentSet({
    bool isPasswordImage = false,
  }) {
    if (isPasswordImage) {
      var passwordImage = setPasswordImagesIndex();
      List<Map<String, dynamic>> tempList = [];
      int count = 0;
      allImageSet.forEach((element) {
        if (count < 8) {
          if (currentImageSet.contains(element)) {
            return;
          } else {
            tempList.add(element);
            count = count + 1;
          }
        } else {
          return;
        }
      });
      currentImageSet.clear();
      if (tempList.length == 8) {
        currentImageSet.add(passwordImage);
        currentImageSet.addAll(tempList);
        currentImageSet.shuffle();
      }
      return currentImageSet;
    } else {
      allImageSet.shuffle();
      currentImageSet = allImageSet.sublist(0, 9);
      currentImageSet.shuffle();
      return currentImageSet;
    }
  }

  // Function to return Single image excluding images from current set
  static String? getSingleRandomImageExceptCurrentSet() {
    List<int> availableIndex = [];
    List<int> currentImageIndex = [];

    currentImageSet.forEach((element) {
      currentImageSet.add(element['index']);
    });

    allImageSet.forEach((element) {
      if (!currentImageIndex.contains(element['index'])) {
        availableIndex.add(element['index']);
      }
    });
    availableIndex.shuffle();
    return allImageSet.elementAt(availableIndex.first)['image'];
  }

  // Funtion to Authenticate User Based on Selected Images and Already Set Images
  static Future<Map<String, dynamic>> authenticateGPAuthUser(
      String username) async {
    if (selectedImages.length == 3) {
      final data = await getGPAuthUserFromFirebase(username);
      if (data['status'] == -1) {
        return {
          "status": -1,
          "errorMessage":
              "Unable to Authenticate User.\nIt may be a technical issue.\nCheck following things:-\n\t1. Your Internet Connection\n\t2. Your Entered Username",
        };
      } else {
        GPAuthUser _user = data['data'] as GPAuthUser;
        if (_user.encryptedPString.isNotEmpty) {
          String pString = "";
          selectedImages.forEach((element) {
            pString += element['label'];
            pString += ";";
          });
          final oPString =
              GPAuthEncryption.decryptGPAuthPassword(_user.encryptedPString);
          if (pString.compareTo(oPString) == 0) {
            return {
              "status": 1,
              "user": _user,
            };
          } else {
            return {
              "status": -1,
              "errorMessage":
                  "Unable to Authenticate User.\nCheck following things:-\n\t1. Your Selected Password\n\t2. Your Entered Username",
            };
          }
        } else {
          return {
            "status": -1,
            "errorMessage":
                "Unable to Authenticate User.\nIt may be a technical issue. Contact Technical Support",
          };
        }
      }
    } else {
      return {
        "status": -1,
        "errorMessage":
            "Unable to Authenticate User.\nCheck following things:-\n\t1. Your Selected Password\n\t2. Your Entered Username\n\t3. You Selected minimum and maximum of 3 Images.",
      };
    }
  }
}
