import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = [];

  Future<File> _getFile() async {
    final localDirectory = await getApplicationDocumentsDirectory();
    return File("${localDirectory.path}/data.json");
  }

  _saveFile() async {
    var file = await _getFile();

    //Criar dados
    Map<String, dynamic> task = Map();
    task["titulo"] = "Ir ao mercado";
    task["check"] = false;
    _toDoList.add(task);

    String data = json.encode(_toDoList);
    file.writeAsString(data);
  }

  _readFile() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _readFile().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        backgroundColor: Colors.purple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Adicionar tarefa"),
                    content: TextField(
                      decoration:
                          InputDecoration(labelText: "Digite sua tarefa"),
                      onChanged: (text) {},
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Cancelar"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      FlatButton(
                        child: Text("Salvar"),
                        onPressed: () {
                          //Criar a função de salvar
                          _saveFile();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                });
          }),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _toDoList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_toDoList[index]['titulo']),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
