// ignore_for_file: avoid_function_literals_in_foreach_calls

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
      }
    });
  }

  // Function to Detect Malicious Activity on Currently Loaded Image Set
  static void detectMaliciousActivity() {}

  // Function to define which set contains Password Image
  static void setPasswordImagesIndex() {
    if (isMaliciousActivityDetected) {
    } else {
      currentImageSet.addAll(passwordImageSet);
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
  static List<Map<String, dynamic>> getRandomImageSetExceptCurrentSet(
      {bool isPasswordImage = false,
      Map<String, dynamic>? passwordImage = const {"image": ""}}) {
    if (isPasswordImage) {
      return [];
    } else {
      allImageSet.shuffle();
      currentImageSet = allImageSet.sublist(0, 9);
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
}
