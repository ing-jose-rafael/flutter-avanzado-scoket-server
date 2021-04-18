import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

//para manear los estados del servidor
enum ServecesStatus { Online, Offline, Connecting }

class SocketServices with ChangeNotifier {
  // creando la propiedad, por default estara en Connecting, dado que cuando creo la instancia
  // no se si esta Online o Offline
  ServecesStatus _servecesStatus = ServecesStatus.Connecting;
  Socket _socket;
  //contructor
  SocketServices() {
    this._initConfig();
  }

  void _initConfig() {
    // Dart client
    this._socket = io(
        'http://localhost:3000',
        OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
            // .disableAutoConnect() // disable auto-connection
            // .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    this._socket.onConnect((_) {
      print('connect');
      this._servecesStatus = ServecesStatus.Online;
      notifyListeners();
    });
    this._socket.onDisconnect((_) {
      print('disconnect');

      this._servecesStatus = ServecesStatus.Offline;
      notifyListeners();
    });

    // this._socket.on('nuevo-mensaje', (data) {
    //   print('nuevo mensaje:');
    //   // como data es un mapa puedo apuntara sus llaves
    //   print('nombre:' + data['nombre']);
    //   print('mensaje:' + data['mensaje']);
    //   // preguntando por si existe una llave en un mapa
    //   print(data.containsKey('mensaje2') ? data['mensaje2'] : 'no existe');
    // });
  }

  ServecesStatus get servecesStatus => this._servecesStatus;
  Socket get socket => this._socket;
  Function get emit => this._socket.emit;
}
