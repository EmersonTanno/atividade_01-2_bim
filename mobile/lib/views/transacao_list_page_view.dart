import 'package:flutter/material.dart';
import 'package:atividade_01/services/transacao_service.dart';

class TransacaoListPageView extends StatefulWidget {
  const TransacaoListPageView({Key? key}) : super(key: key);

  @override
  _TransacaoListPageViewState createState() => _TransacaoListPageViewState();
}

class _TransacaoListPageViewState extends State<TransacaoListPageView> {
  final TransacaoService transacaoService = TransacaoService();
  List<dynamic> transacoes = [];

  @override
  void initState() {
    super.initState();
    _fetchTransacoes();
  }

  Future<void> _fetchTransacoes() async {
    try {
      transacoes = await transacaoService.getAll();
      setState(() {});
    } catch (e) {
      print('Erro ao carregar transações: $e');
    }
  }

  Future<void> _deleteTransacao(int id) async {
    try {
      await transacaoService.delete(id);
      _fetchTransacoes();
    } catch (e) {
      print('Erro ao excluir transação: $e');
    }
  }

  void _showDeleteDialogue(dynamic transacao) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                'Deletar a transação de ${transacao['nome']}, no valor de R\$${transacao['valor']}?'),
            content: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancelar')),
                  ElevatedButton(
                      onPressed: () {
                        _deleteTransacao(int.parse(transacao['id']));
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Deletar',
                        style: TextStyle(color: Colors.red),
                      ))
                ],
              ),
            ),
          );
        });
  }

  void _showEditDialog(Map<String, dynamic> transacao) {
    String nome = transacao['nome'];
    double valor = transacao['valor'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Transação'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Nome'),
                  controller: TextEditingController(text: nome),
                  onChanged: (value) {
                    nome = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Valor'),
                  controller: TextEditingController(text: valor.toString()),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    valor = double.tryParse(value) ?? 0.0;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (nome.isNotEmpty && valor > 0) {
                  transacaoService.update(int.parse(transacao['id']), {
                    'nome': nome,
                    'valor': valor,
                  }).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Transação editada com sucesso!')),
                    );
                    Navigator.of(context).pop();
                    _fetchTransacoes();
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Erro ao editar transação: $error')),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Por favor, preencha os campos corretamente.')),
                  );
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Transações'),
      ),
      body: ListView.builder(
        itemCount: transacoes.length,
        itemBuilder: (context, index) {
          final transacao = transacoes[index];
          return ListTile(
            title: Text(transacao['nome']),
            subtitle: Text('Valor: ${transacao['valor']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditDialog(transacao);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteDialogue(transacao);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
