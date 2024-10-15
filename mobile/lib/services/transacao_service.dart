import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:atividade_01/services/abstract_service.dart';

class TransacaoService extends AbstractService {

  TransacaoService() : super('transacoes');

  @override
  Future create(Map<String, dynamic> data) async {
    List<dynamic> transacoes = await getAll();
    int nextId;
    
    if (transacoes.isNotEmpty) {
      nextId = transacoes.map((transacao) => int.parse(transacao['id'])).reduce((curr, next) => curr > next ? curr : next) + 1;
    } else {
      nextId = 1;
    }

    data['id'] = nextId.toString();

    var response = await http.post(
      Uri.parse('$urlLocalHost/transacoes'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      print('Transação criada com sucesso!');
    } else {
      throw Exception('Falha ao criar transação: ${response.statusCode}');
    }
  }


  @override
  Future update(int id, Map<String, dynamic> dadosAtualizados) async {
    var transacaoAtual = await getById(id);

    var novosDados = {
      "id": id,
      "nome": dadosAtualizados['nome'] ?? transacaoAtual['nome'],
      "valor": dadosAtualizados['valor'] ?? transacaoAtual['valor'],
    };

    var response = await http.put(
      Uri.parse('$urlLocalHost/transacoes/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(novosDados),
    );

    if (response.statusCode == 200) {
      print('Transação atualizada com sucesso!');
    } else {
      throw Exception('Falha ao atualizar transação: ${response.statusCode}');
    }
  }


}