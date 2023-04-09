import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../lexical_anallyzer/tokens/token.dart';
import '../lexical_anallyzer/tokens/value_tokens.dart';

class LexicalAnalyzerPage extends ConsumerWidget {
  const LexicalAnalyzerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _LexicalAnalyzerPage();
  }
}

class _LexicalAnalyzerPage extends ConsumerStatefulWidget {
  const _LexicalAnalyzerPage();

  @override
  ConsumerState<_LexicalAnalyzerPage> createState() =>
      _LexicalAnalyzerPageState();
}

class _LexicalAnalyzerPageState extends ConsumerState<_LexicalAnalyzerPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final anOutput = ref.watch(tokenOutputProveder);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 16),
            width: 400,
            child: Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Входной код',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: ref.read(inputProvider),
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ),
          if (anOutput?.identifiers.isNotEmpty ?? false)
            TokensTextField(
              tokens: anOutput?.identifiers ?? [],
            ),
          if ((anOutput?.numberValues.isNotEmpty ?? false) ||
              (anOutput?.stringValues.isNotEmpty ?? false) ||
              (anOutput?.boolValues.isNotEmpty ?? false))
            TokensTextField(
              tokens: (anOutput?.numberValues ?? []) +
                  (anOutput?.stringValues ?? []) +
                  (anOutput?.boolValues ?? []),
            ),
          Container(
            padding: const EdgeInsets.only(left: 16),
            width: 400,
            child: Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Выходные токены',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: ref.read(outputProvider),
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TokensTextField extends ConsumerWidget {
  final List<Token> tokens;

  const TokensTextField({required this.tokens, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var map =
        tokens.map((e) => "\"${e.encode()}\": \"${e.lexeme}\" ").join(",\n");
    if (tokens.isNotEmpty && tokens.first is ValToken) {
      final valTokens = tokens.whereType<ValToken>();
      map = valTokens
          .map((e) => "\"${e.encode()}\": \"${e.value}\" ")
          .join(",\n");
    }
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: SizedBox(
        width: 200,
        child: Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tokens.first is ValueToken
                    ? 'Токены констант'
                    : 'Индентификаторы',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(text: map),
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
