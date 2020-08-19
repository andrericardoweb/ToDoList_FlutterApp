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
  TextEditingController _controllerTask = TextEditingController();

  Future<File> _getFile() async {
    final localDirectory = await getApplicationDocumentsDirectory();
    return File("${localDirectory.path}/data.json");
  }

  _saveTask() {
    String typedText = _controllerTask.text;

    Map<String, dynamic> task = Map();
    task["titulo"] = typedText;
    task["completed"] = false;

    setState(() {
      _toDoList.add(task);
    });

    _saveFile();
    _controllerTask.text = "";
  }

  _saveFile() async {
    var file = await _getFile();

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
                      controller: _controllerTask,
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
                          _saveTask();
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
                  
                  /*
                  return ListTile(
                    title: Text(_toDoList[index]['titulo']),
                  );
                  */

                  return CheckboxListTile(
                    title: Text(_toDoList[index]['titulo']),
                    value: _toDoList[index]['completed'],
                    onChanged: (changedValue) {
                      setState(() {
                        _toDoList[index]['completed'] = changedValue;
                      });
                      
                      _saveFile();
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
