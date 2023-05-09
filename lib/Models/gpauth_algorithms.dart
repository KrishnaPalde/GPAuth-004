// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:math';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:gpauth_004/Models/database.dart';
import 'package:gpauth_004/Models/gpauth_encryption.dart';
import 'package:gpauth_004/Models/gpauth_user.dart';
import 'package:gpauth_004/Models/image_set.dart';
import 'package:gpauth_004/Screens/login_screen.dart';

class GPAuthAlgorithms {
  static bool isMaliciousActivityDetected = false;
  static int passwordAttempts = 0;
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
    allImageSet.addAll(obj.imageSet5); // Extra ImageSet
  }

  // Adds Particular Image to Selected Image Set from Current Image Set
  static void selectImageFromCurrentSet(int index) {
    // if (selectedImages.length > 1) {
    //   detectMaliciousActivity();
    // }
    print(index);
    if (selectedImages.length < 3) {
      selectedImages.add(currentImageSet[index]);
      getSingleRandomImageExceptCurrentSet(index);
    } else {
      Fluttertoast.showToast(msg: "Please Select only 3 Password Images");
    }
  }

  // Function to Detect Malicious Activity on Currently Loaded Image Set
  // Not Perfect
  static void detectMaliciousActivity() {
    int flag = 0;
    if (passwordAttempts >= 2) {
      if (selectedImages.length == 2 || selectedImages.length == 3) {
        for (int i = 0; i < selectedImages.length; i++) {
          if (selectedImages.first != passwordImageSet.first) {
            flag = 1;
            break;
          } else {
            flag = 0;
          }
          if (selectedImages[1] != passwordImageSet[1]) {
            flag = 1;
            break;
          } else {
            flag = 0;
          }
          if (selectedImages.length == 3) {
            if (selectedImages[2] != passwordImageSet[2]) {
              flag = 1;
              break;
            } else {
              flag = 0;
            }
          }
        }
        // selectedImages.forEach((element1) {
        //   // if (!passwordImageSet.contains(passwordImageSet.singleWhere(
        //   //     (element) => element['label'] == element1['label']))) {
        //   if (!passwordImageSet.contains(element1)) {
        //     if (flag == 0) {
        //       flag = 1;
        //     }
        //   } else {
        //     flag = 0;
        //   }
        // });
      }
    }
    if (flag == 1) {
      isMaliciousActivityDetected = true;
      // malici
    }
  }

  // Clear Selected Image Set
  static void removeAllSelectedImage() {
    selectedImages.clear();
    print("CLEARED");
  }

  // Function to populate Password Image Set
  // labels List must contain lowercase labels
  static void populatePasswordImageSet(List<String> labels) {
    // for (var element in allImageSet) {
    //   if(labels.contains(element['label'].toString().toLowerCase())){
    //     passwordImageSet.add(element);
    //   }
    // }
    // allImageSet.forEach((element) {
    //   if (labels.contains(element['label'].toString().toLowerCase())) {
    //     passwordImageSet.add(element);
    //   }
    // });
    allImageSet.forEach((element) {
      print(element['label']);
    });
    passwordImageSet.addAll(allImageSet.where((element) =>
        labels.contains(element['label'].toString().toLowerCase())));
    // passwordImageSet.add(allImageSet
    //     .singleWhere((element) => element['label'] == 'elephant-right'));

    print(labels);
    print(passwordImageSet);
    // allImageSet.removeWhere((element) =>
    //     labels.contains(element['label'].toString().toLowerCase()));
  }

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
      // currentImageSet.addAll(passwordImageSet);
      return {
        "isPasswordImage": false,
        "passwordImageElement": {},
      };
    }
  }

  static void getFirstImageSet() {
    List<Map<String, dynamic>> _temp = [];
    _temp.addAll(passwordImageSet);
    allImageSet.shuffle();
    // currentImageSet.addAll(passwordImageSet);
    // allImageSet.shuffle();
    // currentImageSet
    //     .addAll(allImageSet.sublist(0, (9 - currentImageSet.length)));
    _temp.addAll(allImageSet.sublist(0, (9 - currentImageSet.length)));
    List _tempElement = [];
    int flag = 0;
    _temp.forEach((element) {
      if (_tempElement.contains(element)) {
        flag = 1;
      } else {
        _tempElement.add(element);
      }
    });
    while (flag != 0) {
      _tempElement.clear();
      allImageSet.shuffle();
      _temp.clear();
      _temp.addAll(allImageSet.sublist(0, (9 - currentImageSet.length)));
      _temp.forEach((element) {
        if (_tempElement.contains(element)) {
          flag = 1;
        } else {
          _tempElement.add(element);
        }
      });
    }
    currentImageSet = _temp;
    currentImageSet.shuffle();
  }

  // Function to return Set of 9 Images excluding current images
  static void getRandomImageSetExceptCurrentSet() {
    print(currentImageSet);
    var passwordData = setPasswordImagesIndex();
    if (passwordData['isPasswordImage']) {
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
        currentImageSet.add(passwordData['passwordImageElement']);
        currentImageSet.addAll(tempList);
        currentImageSet.shuffle();
      }
    } else {
      allImageSet.shuffle();
      currentImageSet = allImageSet.sublist(0, 9);
      currentImageSet.shuffle();
      print(currentImageSet);
    }
  }

  // Function to return Single image excluding images from current set
  static void getSingleRandomImageExceptCurrentSet(int index) {
    List<int> availableIndex = [];
    List<int> currentImageIndex = [];

    currentImageSet.forEach((element) {
      currentImageIndex.add(element['index']);
    });

    allImageSet.forEach((element) {
      if (!currentImageIndex.contains(element['index'])) {
        availableIndex.add(element['index']);
      }
    });
    availableIndex.shuffle();
    while (passwordImageSet
            .contains(allImageSet.elementAt(availableIndex.first)) &&
        currentImageSet.contains(allImageSet.elementAt(availableIndex.first))) {
      availableIndex.shuffle();
    }
    currentImageSet[index] = allImageSet.elementAt(availableIndex.first);
  }

  // Funtion to Authenticate User Based on Selected Images and Already Set Images
  static Future<Map<String, dynamic>> authenticateGPAuthUser(
      String username) async {
    if (selectedImages.length == 3 && passwordAttempts < 3) {
      final data = await getGPAuthUserFromFirebase(username);
      if (data['status'] == -1) {
        Fluttertoast.showToast(msg: "Technical Error");
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
            Fluttertoast.showToast(msg: "Authentication Successful");
            return {
              "status": 1,
              "user": _user,
            };
          } else {
            passwordAttempts += 1;
            Fluttertoast.showToast(msg: "Invalid Password");
            return {
              "status": -1,
              "errorMessage":
                  "Unable to Authenticate User.\nCheck following things:-\n\t1. Your Selected Password\n\t2. Your Entered Username",
            };
          }
        } else {
          Fluttertoast.showToast(msg: "Technical Error");
          return {
            "status": -1,
            "errorMessage":
                "Unable to Authenticate User.\nIt may be a technical issue. Contact Technical Support",
          };
        }
      }
    } else if (passwordAttempts == 3) {
      Fluttertoast.showToast(msg: "Your Password Attempt Limit is Exhausted");
      return {
        "status": -1,
        "errorMessage": "Unable to Authenticate User.",
      };
    } else {
      Fluttertoast.showToast(msg: "Select 3 Password Images only");
      return {
        "status": -1,
        "errorMessage":
            "Unable to Authenticate User.\nCheck following things:-\n\t1. Your Selected Password\n\t2. Your Entered Username\n\t3. You Selected minimum and maximum of 3 Images.",
      };
    }
  }
}
