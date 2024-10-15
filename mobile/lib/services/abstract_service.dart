import 'dart:convert'; 
import 'package:http/http.dart' as http;

abstract class AbstractService {
  final String urlLocalHost = 'http://localhost:3000';
  String _recurso;

  AbstractService(this._recurso);
  String get recurso => _recurso;

  Future<List<dynamic>> getAll() async {
    var response = await http.get(Uri.parse('$urlLocalHost/$_recurso'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Falha ao carregar dados: ${response.statusCode}');
    }
  }

  Future<dynamic> getById(int id) async {
    var response = await http.get(Uri.parse('$urlLocalHost/$_recurso/$id'));

    if (response.statusCode == 200) {
      dynamic jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Falha ao carregar dados: ${response.statusCode}');
    }
  }

  Future create(Map<String, dynamic> data);

  Future update(int id, Map<String, dynamic> dadosAtualizados);


  Future delete(int id) async {
    var response = await http.delete(
      Uri.parse('$urlLocalHost/$_recurso/$id'),
    );

    if (response.statusCode == 200) {
      print('Transação deletada com sucesso!');
    } else {
      throw Exception('Falha ao deletar transação: ${response.statusCode}');
    }
  }
}
