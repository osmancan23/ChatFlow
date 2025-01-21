/*
import 'package:flutter_file_compressor/flutter_file_compressor.dart';
import 'package:image/image.dart' as img;

extension FileCompressExtension on File {
  Future<dynamic> compressFile() async => FlutterFileCompressor.compressFile(
        filePath: path,
        compressionType: CompressionType.image,
        quality: 50,
      );

  File compressAndResizeImage() {
    final image = img.decodeImage(readAsBytesSync());

    // Resize the image to have the longer side be 800 pixels
    int width;
    int height;

    if (image!.width > image.height) {
      width = 800;
      height = (image.height / image.width * 800).round();
    } else {
      height = 800;
      width = (image.width / image.height * 800).round();
    }

    final resizedImage = img.copyResize(image, width: width, height: height);

    // Compress the image with JPEG format
    final List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 85); // Adjust quality as needed

    // Save the compressed image to a file
    final compressedFile = File(path.replaceFirst('.jpg', '_compressed.jpg'));
    compressedFile.writeAsBytesSync(compressedBytes);

    return compressedFile;
  }
}*/
