import 'package:flutter/material.dart';
import 'package:atividade_01/services/transacao_service.dart';

class FormPageView extends StatefulWidget {
  const FormPageView({super.key});

  @override
  _FormPageViewState createState() => _FormPageViewState();
}

class _FormPageViewState extends State<FormPageView> {
  final TransacaoService transacaoService = TransacaoService();
  
  String nome = '';
  double valor = 0.0;

  final _formKey = GlobalKey<FormState>(); // Chave para o formulário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo para Nome
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
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
              const SizedBox(height: 16), // Espaçamento entre os campos

              // Campo para Valor
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Valor',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    valor = double.tryParse(value) ?? 0.0; // Tenta converter para double
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um valor.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um valor válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20), // Espaçamento entre os campos

              // Botão para Criar Transação
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Chama o método para criar a transação
                    transacaoService.create({'nome': nome, 'valor': valor}).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Transação criada com sucesso!')),
                      );
                      // Limpa os campos após criar a transação
                      setState(() {
                        nome = '';
                        valor = 0.0;
                      });
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao criar transação: $error')),
                      );
                    });
                  }
                },
                child: const Text('Criar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
