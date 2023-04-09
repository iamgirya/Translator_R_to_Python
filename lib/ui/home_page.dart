import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../reverse_polish_entry/reverse_polish_entry.dart';
import 'lexical_analyzer_page.dart';

import '../core/providers.dart';
import '../lexical_anallyzer/lexical_analyzer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  void generateTokens() {
    String inputText = ref.read(inputProvider).text;
    final tokenOutput = ref.read(tokenOutputProvider.notifier);

    tokenOutput.update((state) => LexicalAnalyzer().execute(inputText));
    String output = tokenOutput.state.convertToText();

    ref.read(outputProvider).text = output;
  }

  void generateReversePolishEntry() {
    String inputText = ref.read(inputProvider).text;

    ref
        .read(tokenOutputProvider.notifier)
        .update((state) => LexicalAnalyzer().execute(inputText));

    String output = ReversePolishEntry()
        .execute(ref.read(tokenOutputProvider))
        .convertToText();

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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
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
              'Лаба 1',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
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
              'Лаба 2',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
