class ImageSet {
  String imagesetName;
  List<Map<String, dynamic>> imageSet;
  List<Map<String, dynamic>> imageSet1;
  List<Map<String, dynamic>> imageSet2;
  List<Map<String, dynamic>> imageSet3;
  List<Map<String, dynamic>> imageSet4;
  List<Map<String, dynamic>> imageSet5;

  ImageSet(this.imagesetName, this.imageSet, this.imageSet1, this.imageSet2,
      this.imageSet3, this.imageSet4, this.imageSet5);

  factory ImageSet.fromJson(Map<String, dynamic> json) => ImageSet(
        json['imageSetName'] ?? "",
        json['imageSet'].isEmpty
            ? [{}]
            : List<Map<String, dynamic>>.from(json['imageSet'] as List),
        json['imageSet1'].isEmpty
            ? [{}]
            : List<Map<String, dynamic>>.from(json['imageSet1'] as List),
        json['imageSet2'].isEmpty
            ? [{}]
            : List<Map<String, dynamic>>.from(json['imageSet2'] as List),
        json['imageSet3'].isEmpty
            ? [{}]
            : List<Map<String, dynamic>>.from(json['imageSet3'] as List),
        json['imageSet4'].isEmpty
            ? [{}]
            : List<Map<String, dynamic>>.from(json['imageSet4'] as List),
        json['imageSet5'].isEmpty
            ? [{}]
            : List<Map<String, dynamic>>.from(json['imageSet5'] as List),
        // json['imageSet'] ?? "",
        // json['birthDate'] ?? "",
        // json['gender'] ?? "",
        // json['telephone'] ?? "",
        // json['profileImage'] ?? "",
        // json['cart'] ?? <String, dynamic>{},
        // json['wishlist'] ?? [],
        // json['defaultAddress'] ?? <String, dynamic>{},
        // json['addresses'] ?? [],
      );

  List<Map<String, dynamic>> getImageSet() {
    return imageSet;
  }

  String getImageSetName() {
    return imagesetName;
  }
}
