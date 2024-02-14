import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

// ignore: constant_identifier_names
enum ServerStatus { Online, Offline, Conneting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Conneting;
  IO.Socket? _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket!;
  get emit => _socket?.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    //Dart CLient
    _socket = IO.io('http://192.168.1.4:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    _socket!.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket!.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }
}
