class ImageSet {
  String imagesetName;
  List<String> imageSet;

  ImageSet(this.imagesetName, this.imageSet);

  factory ImageSet.fromJson(Map<String, dynamic> json) => ImageSet(
        json['imageSetName'] ?? "",
        json['imageSet'] ?? "",
        // json['birthDate'] ?? "",
        // json['gender'] ?? "",
        // json['telephone'] ?? "",
        // json['profileImage'] ?? "",
        // json['cart'] ?? <String, dynamic>{},
        // json['wishlist'] ?? [],
        // json['defaultAddress'] ?? <String, dynamic>{},
        // json['addresses'] ?? [],
      );
}
