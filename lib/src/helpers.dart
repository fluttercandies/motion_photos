import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:motion_photos/src/constants.dart';
import 'package:motion_photos/src/video_index.dart';
import 'package:motion_photos/src/xmp_extractor.dart';

///This class is a helper class which handles all
///the actions required for the motion photo main methods
class MotionPhotoHelpers {
  ///This Method takes [filePath] as parameter
  ///and return [Uint8List] synchronously
  static Uint8List pathToBytes(String filePath) {
    if (filePath.isEmpty) throw 'File Path Is Empty';
    File file = File(filePath);
    return file.readAsBytesSync();
  }

  ///extractVideoIndexFromXMP takes file [bytes] as parameter
  /// and return [VideoIndex] of the motion photo using the XMP data
  static VideoIndex? extractVideoIndexFromXMP(Uint8List bytes) {
    try {
      final Map<String, dynamic> xmpData = XMPExtractor().extract(bytes);
      final int size = bytes.lengthInBytes;
      for (String offSetKey in MotionPhotoConstants.fileOffsetKeys) {
        if (xmpData.containsKey(offSetKey)) {
          final offsetFromEnd = int.parse(xmpData[offSetKey]);
          return VideoIndex(start: size - offsetFromEnd, end: size);
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
