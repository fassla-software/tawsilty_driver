import 'dart:io';

class ImageFileHelper{

  static String calculateFileSize(String filePath){
    final file = File(filePath);
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes /  1024;

    return '${sizeInMb.toInt()} ${'kb'}';
  }
}