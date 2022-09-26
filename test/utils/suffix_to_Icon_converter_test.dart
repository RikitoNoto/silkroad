import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:silkroad/utils/suffix_to_Icon_converter.dart';


void main() {
  commandConvertTest();
}

void commandConvertTest() {
  group('convert icon from suffix test', () {
    test('should be return null if none suffix', () async {
      expect(SuffixToIconConverter.convertIcon('A'), null);
    });

    test('should be return description if suffix is [txt]', () async {
      expect(SuffixToIconConverter.convertIcon('A.txt'), Icons.description);
    });

    test('should be return image if suffix is [jpeg]', () async {
      expect(SuffixToIconConverter.convertIcon('A.jpeg'), Icons.image);
    });

    test('should be return image if suffix is [jpg]', () async {
      expect(SuffixToIconConverter.convertIcon('A.jpg'), Icons.image);
    });

    test('should be return image if suffix is [png]', () async {
      expect(SuffixToIconConverter.convertIcon('A.png'), Icons.image);
    });

    test('should be return image if suffix is [bmp]', () async {
      expect(SuffixToIconConverter.convertIcon('A.bmp'), Icons.image);
    });

    test('should be return image if suffix is [tiff]', () async {
      expect(SuffixToIconConverter.convertIcon('A.tiff'), Icons.image);
    });

    test('should be return image if suffix is [tif]', () async {
      expect(SuffixToIconConverter.convertIcon('A.tif'), Icons.image);
    });

    test('should be return gif if suffix is [gif]', () async {
      expect(SuffixToIconConverter.convertIcon('A.gif'), Icons.gif);
    });

    test('should be return picture_as_pdf if suffix is [pdf]', () async {
      expect(SuffixToIconConverter.convertIcon('A.pdf'), Icons.picture_as_pdf);
    });

    test('should be return music_note if suffix is [mp3]', () async {
      expect(SuffixToIconConverter.convertIcon('A.mp3'), Icons.music_note);
    });

    test('should be return movie if suffix is [mp4]', () async {
      expect(SuffixToIconConverter.convertIcon('A.mp4'), Icons.movie);
    });

    test('should be return description if suffix is [.jpeg.txt]', () async {
      expect(SuffixToIconConverter.convertIcon('A.jpeg.txt'), Icons.description);
    });
  });
}
