import 'package:appimc/classes/imc.dart';

class ImcRepository {
  final List<Imc> _imcs = [];

  Future<void> adicionar(Imc tarefa) async {
    _imcs.add(tarefa);
  }

  Future<void> alterar(String id, bool concluido) async {
//    _imcs.where((tarefa) => tarefa.id == id).first.concluido = concluido;
  }

  Future<List<Imc>> getListaDeImc() async {
    return _imcs;
  }

  Future<void> remove(String id) async {
    _imcs.remove(_imcs.where((imcs) => imcs.id == id).first);
  }
}
