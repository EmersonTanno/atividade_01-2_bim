import 'package:flutter/material.dart';
import 'package:atividade_01/services/transacao_service.dart';

class FormPageView extends StatefulWidget {
  const FormPageView({super.key});

  @override
  _FormPageViewState createState() => _FormPageViewState();
}

class _FormPageViewState extends State<FormPageView> {
  final TransacaoService transacaoService = TransacaoService();
  final _formKey = GlobalKey<FormState>();

  String nome = '';
  double valor = 0.0;

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController valorController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    valorController.dispose();
    super.dispose();
  }

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
              TextFormField(
                controller: nomeController,
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
              const SizedBox(height: 16), 

              TextFormField(
                controller: valorController,
                decoration: InputDecoration(
                  labelText: 'Valor',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    valor = double.tryParse(value) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um valor.';
                  }
                  if (double.tryParse(value) == null || double.tryParse(value)! <= 0) {
                    return 'Por favor, insira um valor válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    transacaoService.create({'nome': nome, 'valor': valor}).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Transação criada com sucesso!')),
                      );
    
                      setState(() {
                        nome = '';
                        valor = 0.0;
                        nomeController.clear();
                        valorController.clear();
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

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.list),
        onPressed: () {
          Navigator.of(context).pushNamed('/listTransacao');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
