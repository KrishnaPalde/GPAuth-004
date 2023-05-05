import 'package:encrypt/encrypt.dart';
import 'package:gpauth_004/config/config.dart';

class GPAuthEncryption {
  static String encryptGPAuthPassword(String password) {
    final encrypter = Encrypter(AES(GPAuthKey));
    final encrypted = encrypter.encrypt(password, iv: GPAuthIV);
    return encrypted.base64;
  }

  static String decryptGPAuthPassword(String encryptedPassword) {
    final encrypter = Encrypter(AES(GPAuthKey));
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(encryptedPassword),
        iv: GPAuthIV);
    return decrypted;
  }
}
