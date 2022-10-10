import 'package:flutter/material.dart';

enum MimeType{
  text,
  image,
  music,
  movie,
  gif,
  pdf,
}

class SuffixAnalyzer{

  static const Map<String, IconData> _convertTable = {
    /// text
    'txt'   : Icons.description,

    /// image
    'jpeg'  : Icons.image,
    'jpg'   : Icons.image,
    'png'   : Icons.image,
    'bmp'   : Icons.image,
    'tiff'  : Icons.image,
    'tif'   : Icons.image,

    /// music
    'mp3'   : Icons.music_note,

    /// movie
    'mp4'   : Icons.movie,

    /// gif
    'gif'   : Icons.gif,

    /// pdf
    'pdf'   : Icons.picture_as_pdf,
  };

  static IconData? convertIcon(String filename){
    String? suffix = RegExp('\.([^.]*)\$').firstMatch(filename)?.group(1);

    if(suffix != null){
      return _convertTable[suffix];
    }

    return null;
  }
}
