import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Press Java code',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const TextField(
                      maxLines: 32,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 62),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Output Tokens',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const TextField(
                      maxLines: 32,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
