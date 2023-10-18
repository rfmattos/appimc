import 'package:appimc/classes/imc.dart';
import 'package:flutter/material.dart';
import 'package:appimc/repository/imc_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  final String titulo = "Calculadora de IMC";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _peso = TextEditingController();
  final _altura = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static ImcRepository imcRepository = ImcRepository();
  int tamanhoDaLista = 0;
  List<Imc> listaDeImc = <Imc>[];

  @override
  void initState() {
    super.initState();
    Future<List<Imc>> listaDeImc = imcRepository.getListaDeImc();
    listaDeImc.then((novaListaDeImc) {
      setState(() {
        this.listaDeImc = novaListaDeImc;
        tamanhoDaLista = novaListaDeImc.length;
      });
    });
  }

  _carregarLista() async {
    Future<List<Imc>> noteListFuture = imcRepository.getListaDeImc();
    noteListFuture.then((novaListaDeImc) {
      setState(() {
        listaDeImc = novaListaDeImc;
        tamanhoDaLista = novaListaDeImc.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      body: _listaDeImc(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _adicionarImc();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget campoDeAltura() {
    return TextFormField(
      controller: _altura,
      keyboardType: TextInputType.number,
      validator: (valor) {
        if ((valor!.isEmpty) || (double.parse(_altura.text) == 0)) {
          return "Campo Obrigatório";
        }
      },
      decoration: const InputDecoration(
        hintText: 'altura (Ex:120 cm)',
        labelText: 'altura (Ex:120 cm)',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget campoDePeso() {
    return TextFormField(
      controller: _peso,
      keyboardType: TextInputType.number,
      validator: (valor) {
        if ((valor!.isEmpty) || (double.parse(_peso.text) == 0)) {
          return "Campo Obrigatório";
        }
      },
      decoration: const InputDecoration(
        hintText: 'peso (Ex:70.5 kg)',
        labelText: 'peso (Ex:70.5 kg)',
        border: OutlineInputBorder(),
      ),
    );
  }

  void _adicionarImc() {
    _peso.text = '';
    _altura.text = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Novo IMC"),
          content: Container(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  campoDeAltura(),
                  const Divider(
                    color: Colors.transparent,
                    height: 20.0,
                  ),
                  campoDePeso()
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Salvar"),
              onPressed: () {
                Imc _imc;
                if (_formKey.currentState!.validate()) {
                  _imc =
                      Imc(double.parse(_peso.text), double.parse(_altura.text));
                  imcRepository.adicionar(_imc);
                  _carregarLista();
                  _formKey.currentState!.reset();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _listaDeImc() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: tamanhoDaLista,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: ListTile(
            //pego o nome do contato com base na posicao da lista
            title: Text(listaDeImc[index].classificacaoIMC),

            //pego o email do contato com base na posicao da lista
            subtitle: Text(
                "Altura: ${listaDeImc[index].getAltura()} cm, Peso: ${listaDeImc[index].getPeso()} kg"),

            leading: CircleAvatar(
              //pego o nome do contato com base no indice
              // da lista e pego a primeira letra do nome
              backgroundColor: listaDeImc[index].color,
              child: listaDeImc[index].icone,
            ),
          ),
        );
      },
    );
  }
}
