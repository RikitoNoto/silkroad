import 'dart:io';

import 'package:flutter/material.dart';

import 'package:silkroad/comm/comm.dart';
import 'package:silkroad/send/repository/send_repository.dart';
import 'package:silkroad/receive/repository/receive_repository.dart';

final RouteObserver kRouteObserver = RouteObserver();
const int kDefaultPort = 32099;

typedef CommunicationFactoryFunc<T> = CommunicationIF<T> Function();
CommunicationIF<Socket> kCommunicationFactory(){
  return Tcp();
}

typedef SimpleFactoryFunc<T> = T Function();

SendRepository kSendRepositoryDefault(){
  return SendRepositoryCamel();
}

ReceiveRepository kReceiveRepositoryDefault(){
  return ReceiveRepositoryCamel();
}
