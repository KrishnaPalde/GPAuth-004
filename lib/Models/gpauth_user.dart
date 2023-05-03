class GPAuthUser {
  String username;
  String email;
  String imageset;

  GPAuthUser(
    this.username,
    this.email,
    this.imageset,
    //   [
    //   this.birthDate = '',
    //   this.gender = '',
    //   this.telephone = '',
    //   this.profileImage = '',
    //   this.cart,
    //   this.wishlist,
    //   this.defaultAddress,
    //   this.addresses,
    // ]
  );

  factory GPAuthUser.fromJson(Map<String, dynamic> json) => GPAuthUser(
        json['username'] ?? "",
        json['email'] ?? "",
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

  Map<String, dynamic> toJson() => _GPAuthUserToJson(this);

  Map<String, dynamic> _GPAuthUserToJson(GPAuthUser instance) =>
      <String, dynamic>{
        'username': instance.username,
        'email': instance.email,
        'imageSet': instance.imageset,
        // 'birthDate': instance.birthDate,
        // 'gender': instance.gender,
        // 'telephone': instance.telephone,
        // 'profileImage': instance.profileImage,
        // 'cart': instance.cart,
        // 'wishlist': instance.wishlist,
        // 'defaultAddress': instance.defaultAddress,
        // 'addresses': instance.addresses,
      };

  String getUsername() {
    return username;
  }

  String getEmail() {
    return email;
  }

  String getImageSet() {
    return imageset;
  }

  // String getBirthDate() {
  //   return birthDate;
  // }

  // String getGender() {
  //   return gender;
  // }

  // String getTelephone() {
  //   return telephone;
  // }

  // String getProfileImage() {
  //   return profileImage;
  // }

  // Map<String, dynamic>? getCart() {
  //   return cart;
  // }

  // List? getWishlist() {
  //   return wishlist;
  // }

  void setUsername(String un) {
    username = un;
  }

  void setEmail(String emailId) {
    email = emailId;
  }

  void setImageSet(String im) {
    imageset = im;
  }

  // void setBirthDate(String birthdate) {
  //   birthDate = birthdate;
  // }

  // void setGender(String setGender) {
  //   gender = setGender;
  // }

  // void setTelephone(String mobile) {
  //   telephone = mobile;
  // }

  // void setProfileImage(String imageURL) {
  //   profileImage = imageURL;
  // }

  // void addProductToWishlist(prodID) {
  //   wishlist!.add(prodID);
  // }
}
