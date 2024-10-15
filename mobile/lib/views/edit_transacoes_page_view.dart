import 'package:flutter/material.dart';
import 'package:atividade_01/services/transacao_service.dart';

class EditTransacaoPageView extends StatefulWidget {
  final Map<String, dynamic> transacao;

  const EditTransacaoPageView({Key? key, required this.transacao}) : super(key: key);

  @override
  _EditTransacaoPageViewState createState() => _EditTransacaoPageViewState();
}

class _EditTransacaoPageViewState extends State<EditTransacaoPageView> {
  final TransacaoService transacaoService = TransacaoService();
  
  late String nome;
  late double valor;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nome = widget.transacao['nome'];
    valor = widget.transacao['valor'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                initialValue: nome,
                onChanged: (value) {
                  setState(() {
                    nome = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16), 

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Valor',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                initialValue: valor.toString(),
                onChanged: (value) {
                  setState(() {
                    valor = double.tryParse(value) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um valor.';
                  }
                  if (double.tryParse(value) == null || double.tryParse(value) !<= 0) {
                    return 'Por favor, insira um valor válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    transacaoService.update(widget.transacao['id'], {
                      'nome': nome,
                      'valor': valor
                    }).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Transação editada com sucesso!')),
                      );
                      Navigator.of(context).pop(); // Volta para a tela anterior
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao editar transação: $error')),
                      );
                    });
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
