import 'dart:io';

import 'package:band_name_app/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:band_name_app/models/band_model.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    // Band(id: '1', name: 'Silvestre Dangond', votes: 2),
    // Band(id: '2', name: 'Poncho Zuleta', votes: 3),
    // Band(id: '3', name: 'Beto Zabaleta', votes: 4),
    // Band(id: '4', name: 'Ivan Villazón', votes: 3),
  ];

  @override
  void initState() {
    // listen en false por que no se va a redibujar nada cuando cambie el providers
    final socketServices = Provider.of<SocketServices>(context, listen: false);
    /**
     * Opcion 1 
     */
    // socketServices.socket.on('Active-bands', (payload) {
    //   /* payload es un listado que dentro contiene un Map */
    //   // print(payload);
    //   /** Casteamos el payload como una lista, luego con la funcion map transformamos cada uno
    //    * de sus objetos y los asignamos como una lista iterable a bands
    //    */
    //   this.bands = (payload as List).map((e) => Band.fromMap(e)).toList();
    //   // para que se redibuje cada vez que reciba un evento del servidor
    //   setState(() {});
    // });

    /**
     * Opcion 2 
     */
    socketServices.socket.on('Active-bands', _handleActiveBands);

    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    this.bands = (payload as List).map((e) => Band.fromMap(e)).toList();

    setState(() {});
  }

  // buena practica cuando se destruya la pantalla
  @override
  void dispose() {
    final socketServices = Provider.of<SocketServices>(context, listen: false);
    socketServices.socket.off('Active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketServices = Provider.of<SocketServices>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grupos Vallenatos',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: (socketServices.servecesStatus == ServecesStatus.Online)
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(Icons.offline_bolt, color: Colors.red[300]),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => _bandListTile(bands[i]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: Icon(Icons.add),
        onPressed: _addNewBand,
      ),
    );
  }

  Widget _bandListTile(Band band) {
    final socketServices = Provider.of<SocketServices>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd, // bloqueando la direccion
      onDismissed: (DismissDirection direction) =>
          socketServices.emit('delete-band', {'id': band.id}),
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
        onTap: () => socketServices.socket.emit('vote-band', {'id': band.id}),
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
        builder: (_) => AlertDialog(
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
        ),
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
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
      ),
    );
  }

  void _addBandToList(String name) {
    final socketServices = Provider.of<SocketServices>(context, listen: false);
    if (name.length > 1) {
      // lo agregamos
      // bands.add(new Band(
      //   // id: DateTime.now().toString(),
      //   name: name,
      //   votes: 0,
      // ));

      // print(band);
      // socketServices.socket.emit('vote-band', {'id': band);
      socketServices.socket.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
    bands.forEach((e) {
      dataMap.putIfAbsent(e.name, () => e.votes.toDouble());
    });
    Map<String, double> dataMap2 = {
      "Sin Datos": 0,
    };
    List<Color> colorList = [
      Colors.red[50],
      Colors.red[200],
      Colors.blue[50],
      Colors.blue[200],
      Colors.yellow[50],
      Colors.yellow[200],
      Colors.green[50],
      Colors.green[200],
      Colors.purple[50],
    ];

    // return PieChart(dataMap: dataMap);
    return dataMap.isNotEmpty
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            height: 300,
            child: PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              // chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 2,
              colorList: colorList,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              // centerText: "HYBRID",
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: false,
                showChartValues: true,
                showChartValuesInPercentage: true,
                showChartValuesOutside: false,
                decimalPlaces: 1,
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
