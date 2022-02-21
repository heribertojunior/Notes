import 'package:flutter/material.dart';
import 'package:notes/helper/anotacao_helper.dart';
import 'package:notes/model/notes.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Notes> anotacoes = <Notes>[];
  _exibitTelaCad() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //  backgroundColor: Colors.lightBlue,
          title: Text(
            "Adicionar Anotação",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tituloController,
                autofocus: true,
                decoration: InputDecoration(
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    labelText: "Titulo",
                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    hintText: "Digite titulo..."),
              ),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    labelText: "Descrição",
                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    hintText: "Digite Descrição..."),
              ),
            ],
          ),
          actions: [
            FlatButton(
              onPressed: () {
                return Navigator.pop(context);
              },
              child: Text(
                "Cancelar",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            FlatButton(
              onPressed: () {
                _salvarNote();
                return Navigator.pop(context);
              },
              child: Text(
                "Salvar",
                style: TextStyle(
                    color: Colors.lightBlue, fontWeight: FontWeight.bold),
              ),
            )
          ],
        );
      },
    );
  }

  _recuperarNotes() async {
    List anotacoesReq = await _db.recuperarNotes();
    List<Notes> listaTemp = <Notes>[];

    for (var item in anotacoesReq) {
      Notes nota = Notes.fromMap(item);
      listaTemp.add(nota);
    }
    setState(() {
      anotacoes = listaTemp;
    });
    listaTemp = [];
    print("Lista Notes: " + anotacoesReq.toString());
  }

  _salvarNote() async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    Notes notes = Notes(titulo, descricao, DateTime.now().toString());
    int? res = await _db.salvarNote(notes);
    print("salvar nota: " + res.toString());
    _tituloController.clear();
    _descricaoController.clear();
    _recuperarNotes();
  }

  _dataFormater(String data) {
    
  }

  @override
  void initState() {
    super.initState();
    _recuperarNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Minhas Anotações",
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: anotacoes.length,
              itemBuilder: (context, index) {
                final item = anotacoes[index];
                return Card(
                  //margin: EdgeInsetsGeometry.lerp(),
                  // borderOnForeground: false,
                  //color: Colors.green,
                  elevation: 5,
                  child: ListTile(
                    title: Text(item.titulo.toString()),
                    subtitle: Text(
                        "${_dataFormater(item.data.toString())} - ${item.descricao}"),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          _exibitTelaCad();
        },
      ),
    );
  }
}
