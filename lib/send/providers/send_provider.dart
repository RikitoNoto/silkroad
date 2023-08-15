import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:platform/platform.dart';

import 'package:silkroad/global.dart';
import 'package:silkroad/comm/comm.dart';
import 'package:silkroad/parameter.dart';
import 'package:silkroad/send/entities/sendible_device.dart';
import 'package:silkroad/send/repository/send_repository.dart';
import 'package:silkroad/i18n/translations.g.dart';
import 'package:silkroad/send/views/sendible_list_item.dart';

import '../../utils/models/animated_list_item_model.dart';

enum SendResult {
  success,
  lostFile,
  connectionFail,
  sendFail,
}

extension SendResultMessage on SendResult {
  String get message {
    switch (this) {
      case SendResult.success:
        return t.send.sendResult.success;

      case SendResult.lostFile:
        return t.send.sendResult.lostFile;

      case SendResult.connectionFail:
        return t.send.sendResult.connectionFail;

      case SendResult.sendFail:
        return t.send.sendResult.sendFail;
    }
  }
}

class SendProvider with ChangeNotifier, IpaddressFetcher {
  SendProvider({
    this.builder = kSendRepositoryDefault,
    required this.platform,
    required AnimatedListItemModel<SendibleDevice> sendibleList,
  }) : _sendibleList = sendibleList {
    fetchAndSearchAddresses();
    _sender = builder();
  }

  @visibleForTesting
  SendProvider.noSearch({
    this.builder = kSendRepositoryDefault,
    required this.platform,
    required AnimatedListItemModel<SendibleDevice> sendibleList,
  }) : _sendibleList = sendibleList {
    fetchIpAddress();
    _sender = builder();
  }

  static final String fileNameNoSelect = t.send.fileNone;

  final List<int> _ip = <int>[0, 0, 0, 0];
  final List<String> _addressRange = <String>[];
  File? _file;
  final SimpleFactoryFunc<SendRepository> builder;
  final Platform platform;
  late final SendRepository _sender;

  final AnimatedListItemModel<SendibleDevice> _sendibleList;
  double _searchProgress = 0.0;

  String get filePath => _file?.path ?? '';
  String get ip => _ip.join('.');
  String get fileName {
    File? file = _file;
    return file != null ? p.basename(_file!.path) : fileNameNoSelect;
  }

  int get addressRangeCount => _addressRange.length;
  List<String> get addressRange => _addressRange;
  double get searchProgress => _searchProgress;

  final List<String> _myAddresses = [];

  Future fetchAndSearchAddresses() async {
    await fetchIpAddress();
    await searchDevices();
  }

  Future fetchIpAddress() async {
    _addressRange.clear();
    _myAddresses.clear();
    Set<String> addressRangeSet = <String>{};
    for (String address in await fetchIpv4Addresses(platform)) {
      _myAddresses.add(address);
      List<String> range = IpAddressUtility.getIpAddressRange(address);
      addressRangeSet.add('${range[0]}~${range[1]}');
    }
    _addressRange.addAll(addressRangeSet.toList());
    notifyListeners();
  }

  Future<SendResult> send() async {
    File? file = _file;
    if (file == null) return SendResult.lostFile;
    if (!(await file.exists())) return SendResult.lostFile;

    // send
    try {
      await _sender.send(
          '$ip:${OptionManager().get(Params.port.toString()) ?? kDefaultPort}',
          <String, String>{
            "title": p.basename(file.path),
            //FIXME: this should not do here what split data to list.(should be do in repository)
            "data": (await file.readAsBytes())
                .map<String>((int value) => value.toString())
                .join(','),
          });
    } catch (e) {
      _sender.close();
      return SendResult.sendFail;
    }
    _sender.close();
    return SendResult.success;
  }

  Future<void> searchDevices() async {
    final port = int.parse(
        OptionManager().get(Params.port.toString())?.toString() ??
            kDefaultPort.toString());
    final networkAddresses = <String>[];
    for (int i = 0; i < _myAddresses.length; i++) {
      final networkAddress =
          getNetworkAddress(_myAddresses[i], 24); // subnet length is fixed 24.
      if (networkAddresses.contains(networkAddress)) {
        continue;
      }

      networkAddresses.add(networkAddress);
      final list = await _sender.sendible(
        networkAddress,
        port,
        "${_myAddresses[i]}:$port",
        progressCallback: (progress) =>
            _sendibleProgressCallback(progress, i + 1, _myAddresses.length),
      );
      for (final device in list) {
        _sendibleList.append(device);
      }
    }
  }

  void _sendibleProgressCallback(double progress, int count, int length) {
    final progressPercount = count / length;

    _searchProgress =
        progress * progressPercount + progressPercount * (count - 1);
    notifyListeners();
  }

  void setOctet(int octet, int value) {
    _ip[octet] = value;
  }

  set file(File? file) {
    _file = file;
    notifyListeners();
  }
}
