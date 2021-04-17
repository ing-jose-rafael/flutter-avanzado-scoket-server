import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:band_name_app/models/band_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Silvestre Dangond', votes: 2),
    Band(id: '2', name: 'Poncho Zuleta', votes: 3),
    Band(id: '3', name: 'Beto Zabaleta', votes: 4),
    Band(id: '4', name: 'Ivan Villazón', votes: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grupos Vallenatos',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandListTile(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: Icon(Icons.add),
        onPressed: _addNewBand,
      ),
    );
  }

  Widget _bandListTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd, // bloqueando la direccion
      onDismissed: (DismissDirection direction) {
        //TODO: llamar el borrar en el server
      },
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          print(band.name);
        },
      ),
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Row(
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              'Delete Grup',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  /// Metodo que retorna un dialogo que permite la entrada del nombre de una nueva banda
  _addNewBand() {
    //para obtener el texto del TextField
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      // para Android
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nuevo Cantante'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                child: Text('Add'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => _addBandToList(textController.text),
              )
            ],
          );
        },
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text('Nuevo Grupo'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Add'),
              onPressed: () => _addBandToList(textController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Dismiss'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _addBandToList(String name) {
    if (name.length > 1) {
      // lo agregamos
      bands.add(new Band(
        id: DateTime.now().toString(),
        name: name,
        votes: 0,
      ));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
