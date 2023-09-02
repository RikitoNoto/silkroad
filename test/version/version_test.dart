import 'package:flutter_test/flutter_test.dart';
import 'package:silkroad/version/version.dart';

void main() {
  needUpdateTest();
}

void needUpdateTest() {
  group('need update test', () {
    test("if failed to fetch the version, it doesn't need update", () {
      final version = VersionWithGithubApi.forTest();
      expect(version.isNeedUpdate(), false);
    });

    test("same version doesn't need update", () {
      final version = VersionWithGithubApi.forTest();
      version.current.addAll([0, 0, 0]);
      version.required.addAll([0, 0, 0]);
      expect(version.isNeedUpdate(), false);
    });

    group('compare version test', () {
      // [required, current, expect]
      const compareVersions = [
        [
          [0, 0, 0],
          [0, 0, 1],
          false,
        ],
        [
          [0, 0, 0],
          [0, 1, 0],
          false,
        ],
        [
          [0, 0, 0],
          [1, 0, 0],
          false,
        ],
        [
          [0, 0, 1],
          [0, 0, 0],
          true,
        ],
        [
          [0, 1, 0],
          [0, 0, 0],
          true,
        ],
        [
          [1, 0, 0],
          [0, 0, 0],
          true,
        ],
        [
          [1, 0, 1],
          [1, 1, 0],
          false,
        ],
        [
          [2, 190, 125],
          [2, 190, 126],
          false,
        ],
        [
          [2, 190, 125],
          [2, 190, 124],
          true,
        ],
      ];

      for (final versions in compareVersions) {
        test(
            "should ${versions[2] as bool ? "need" : "not need"} required: ${versions[0]}, current: ${versions[1]}",
            () {
          final version = VersionWithGithubApi.forTest();
          version.required.addAll(versions[0] as List<int>);
          version.current.addAll(versions[1] as List<int>);
          expect(versions[2] as bool, version.isNeedUpdate());
        });
      }
    });
  });
}
