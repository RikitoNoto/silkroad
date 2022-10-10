import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:silkroad/utils/file_analyzer.dart';


void main() {
  commandConvertTest();
  discreteTypeTest();
}

void commandConvertTest() {
  group('convert icon from suffix test', () {
    test('should be return null if none suffix', () async {
      expect(FileAnalyzer.convertIcon('A'), null);
    });

    test('should be return description if suffix is [txt]', () async {
      expect(FileAnalyzer.convertIcon('A.txt'), Icons.description);
    });

    test('should be return image if suffix is [jpeg]', () async {
      expect(FileAnalyzer.convertIcon('A.jpeg'), Icons.image);
    });

    test('should be return image if suffix is [jpg]', () async {
      expect(FileAnalyzer.convertIcon('A.jpg'), Icons.image);
    });

    test('should be return image if suffix is [png]', () async {
      expect(FileAnalyzer.convertIcon('A.png'), Icons.image);
    });

    test('should be return image if suffix is [bmp]', () async {
      expect(FileAnalyzer.convertIcon('A.bmp'), Icons.image);
    });

    test('should be return image if suffix is [tiff]', () async {
      expect(FileAnalyzer.convertIcon('A.tiff'), Icons.image);
    });

    test('should be return image if suffix is [tif]', () async {
      expect(FileAnalyzer.convertIcon('A.tif'), Icons.image);
    });

    test('should be return gif if suffix is [gif]', () async {
      expect(FileAnalyzer.convertIcon('A.gif'), Icons.gif);
    });

    test('should be return picture_as_pdf if suffix is [pdf]', () async {
      expect(FileAnalyzer.convertIcon('A.pdf'), Icons.picture_as_pdf);
    });

    test('should be return music_note if suffix is [mp3]', () async {
      expect(FileAnalyzer.convertIcon('A.mp3'), Icons.music_note);
    });

    test('should be return movie if suffix is [mp4]', () async {
      expect(FileAnalyzer.convertIcon('A.mp4'), Icons.movie);
    });

    test('should be return description if suffix is [.jpeg.txt]', () async {
      expect(FileAnalyzer.convertIcon('A.jpeg.txt'), Icons.description);
    });
  });
}

void discreteTypeTest() {
  group('discrete type test', () {
    test('should be return null if suffix is none', () async {
      expect(FileAnalyzer.getFileType('A'), null);
    });

    test('should be return image if suffix is [jpeg]', () async {
      expect(FileAnalyzer.getFileType('A.jpeg'), DiscreteType.image);
    });

    test('should be return text if suffix is [txt]', () async {
      expect(FileAnalyzer.getFileType('A.txt'), DiscreteType.text);
    });

    test('should be return video if suffix is [mp4]', () async {
      expect(FileAnalyzer.getFileType('A.mp4'), DiscreteType.video);
    });

    test('should be return video if suffix is [txt.mp4]', () async {
      expect(FileAnalyzer.getFileType('A.txt.mp4'), DiscreteType.video);
    });

    test('should be return application if suffix is [pdf]', () async {
      expect(FileAnalyzer.getFileType('A.pdf'), DiscreteType.application);
    });

    test('should be return audio if suffix is [mp3]', () async {
      expect(FileAnalyzer.getFileType('A.mp3'), DiscreteType.audio);
    });
  });
}
