import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_name_app/services/socket_services.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketServices = Provider.of<SocketServices>(context);
    final Map dta = {'nombre': 'jose', 'mensaje': 'te amo'};

    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('ServerStatus: \n${socketServices.servecesStatus}')],
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () {
          socketServices.socket.emit('emitir-mensaje', dta);
        },
      ),
    );
  }
}
