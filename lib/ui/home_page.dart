import 'package:flutter/material.dart';

import 'package:java_to_csharp_translator/ui/lexical_analyzer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text(
            'Транслятор R-Python. Лабораторная работа №1',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
      body: const LexicalAnalyzerPage(),
      floatingActionButton: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          onPressed: () {
            setState(() {
              f();
            });
          },
          child: Text(
            'Перевести',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          )),
    );
  }
}
