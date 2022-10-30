import 'dart:io';

import 'package:flutter/material.dart';

import 'package:silkroad/comm/comm.dart';

final RouteObserver kRouteObserver = RouteObserver();
const int kDefaultPort = 32099;

typedef CommunicationFactoryFunc<T> = CommunicationIF<T> Function();
CommunicationIF<Socket> kCommunicationFactory(){
  return Tcp();
}
