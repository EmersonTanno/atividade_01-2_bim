import 'package:atividade_01/views/form_page_view.dart';
import 'package:atividade_01/views/transacao_list_page_view.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([]),
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.red,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => FormPageView(),
            '/listTransacao': (context) => TransacaoListPageView(),
          }
        );
      },
      child: null,
    );
  }
}