import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';

enum DiscreteType{
  application,
  audio,
  example,
  font,
  image,
  model,
  text,
  video,
}

class FileAnalyzer{

  static const Map<String, IconData> _iconConvertMap = {
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


  static const Map<String, DiscreteType> _discreteTypeMap = <String, DiscreteType>{
    'application' : DiscreteType.application,
    'audio'       : DiscreteType.audio,
    'example'     : DiscreteType.example,
    'font'        : DiscreteType.font,
    'image'       : DiscreteType.image,
    'model'       : DiscreteType.model,
    'text'        : DiscreteType.text,
    'video'       : DiscreteType.video,
  };
  
  static IconData? convertIcon(String filename){
    String? suffix = RegExp('\.([^.]*)\$').firstMatch(filename)?.group(1);

    if(suffix != null){
      return _iconConvertMap[suffix];
    }

    return null;
  }

  static DiscreteType? getFileType(String filename){
    String? mimeType = mime(filename);
    return _getDiscreteType(mimeType);
  }

  static DiscreteType? _getDiscreteType(String? mimeType){
    if(mimeType == null) return null;

    String? discreteTypeStr = RegExp('^(.*)/.*').firstMatch(mimeType)?.group(1);
    return _discreteTypeMap[discreteTypeStr];
  }
}
