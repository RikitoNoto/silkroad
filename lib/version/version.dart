import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

abstract class Version {
  factory Version() {
    return VersionWithGithubApi(
        url:
            "https://api.github.com/repos/rikitonoto/silkroad/contents/required_version");
  }

  List<int> get current;
  List<int> get required;

  bool isNeedUpdate();
}

class VersionWithGithubApi implements Version {
  VersionWithGithubApi({
    required this.url,
    this.branch = "main",
  }) {
    fetchVersion();
  }

  @visibleForTesting
  VersionWithGithubApi.forTest({
    this.url = "",
    this.branch = "",
  });

  final String url;
  final String branch;

  @override
  final List<int> current = [];

  @override
  final List<int> required = [];

  @override
  bool isNeedUpdate() {
    if (current.isEmpty || required.isEmpty) {
      return false;
    }

    for (var i = 0; i < required.length; i++) {
      if (current[i] < required[i]) {
        return true;
      }

      if (current[i] > required[i]) {
        return false;
      }
    }
    return false;
  }

  Future<void> fetchVersion() async {
    fetchCurrentVersion();
    fetchRequiredVersion();
  }

  Future<void> fetchCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    current.clear();
    current.addAll(
        packageInfo.version.split(".").map((e) => int.parse(e)).toList());
  }

  Future<void> fetchRequiredVersion() async {
    final response = await http.get(Uri.parse("$url?ref=$branch"));
    final body = jsonDecode(response.body);
    final contentString = body["content"] as String;

    final contentBase64 =
        base64.decode(contentString.replaceAll(RegExp("\n"), ""));
    String versionString =
        String.fromCharCodes(contentBase64).replaceAll(RegExp("\n"), "");
    required.clear();
    required.addAll(versionString
        .split(".")
        .map(
          (e) => int.parse(e),
        )
        .toList());
  }
}
