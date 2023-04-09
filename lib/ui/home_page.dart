import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'lexical_analyzer_page.dart';

import '../core/providers.dart';
import '../lexical_anallyzer/lexical_analyzer.dart';
import '../lexical_anallyzer/tokens/divider_tokens.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  void generateTokens() {
    String inputText = ref.read(inputProvider).text;

    ref
        .read(tokenOutputProveder.notifier)
        .update((state) => LexicalAnalyzer().execute(inputText));

    String output = ref
        .read(tokenOutputProveder)!
        .tokens
        .map(
          (e) => e == DividerTokens.whitespace
              ? ""
              : DividerTokens.isNewLine(e)
                  ? "\n"
                  : e.encode(),
        )
        .join(" ");

    ref.read(outputProvider).text = output;
  }

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
            generateTokens();
          });
        },
        child: Text(
          'Перевести',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}
