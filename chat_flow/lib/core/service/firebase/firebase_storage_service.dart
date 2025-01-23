import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

enum FirebaseStoragePathEnum {
  avatar;

  String get value {
    switch (this) {
      case avatar:
        return 'avatarImages/${FirebaseAuth.instance.currentUser?.uid}/image.png';
    }
  }
}

@immutable
final class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  ///MARK: Upload file to Firebase Storage. Id is shop id or user id
  Future<String> uploadFile({required File file, required FirebaseStoragePathEnum path}) async {
    final reference = _firebaseStorage.ref(
      path.value,
    );
    // final image = file.compressAndResizeImage();
    final data = await _resizeImage(file);

    final snapshot = await reference.putFile(data);

    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<File> _resizeImage(File image) async {
    // Resmi byte formatına çevir ve yeniden boyutlandır
    final imageFile = File(image.path);
    final imageBytes = await imageFile.readAsBytes();
    final decodedImage = img.decodeImage(imageBytes)!;

    // Örnek boyutlandırma (500x500)
    final resizedImage = img.copyResize(decodedImage, width: 500, height: 500);

    // Geçici klasörde yeni bir dosya oluştur
    final tempDir = await getTemporaryDirectory();
    final resizedFile = File('${tempDir.path}/resized_image.jpg');

    // Byte verilerini kaydet
    // ignore: cascade_invocations
    resizedFile.writeAsBytesSync(img.encodeJpg(resizedImage));

    // Firebase Storage'a yükle
    return resizedFile;
  }
}
