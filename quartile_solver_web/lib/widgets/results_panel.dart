import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

/// Widget for displaying puzzle results
class ResultsPanel extends StatelessWidget {
  const ResultsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final result = appState.currentResult;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Results',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (result != null)
                  PopupMenuButton<SortOrder>(
                    icon: const Icon(Icons.sort),
                    onSelected: appState.setSortOrder,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: SortOrder.original,
                        child: Text('Original Order'),
                      ),
                      const PopupMenuItem(
                        value: SortOrder.alphabetical,
                        child: Text('Alphabetical'),
                      ),
                      const PopupMenuItem(
                        value: SortOrder.byLength,
                        child: Text('By Length'),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (result == null)
              const Expanded(
                child: Center(
                  child: Text(
                    'Enter puzzle tiles and click "Solve Puzzle" to see results',
                    style: TextStyle(color: Color(0xFF8E8E93)),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${result.wordCount} words found',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Processed in ${result.processingTime.inMilliseconds}ms',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _copyResults(context, appState.sortedWords),
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Copy'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _exportResults(context, appState.sortedWords),
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('Export'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E5EA)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    itemCount: appState.sortedWords.length,
                    itemBuilder: (context, index) {
                      final word = appState.sortedWords[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: index.isEven ? Colors.white : const Color(0xFFFAFAFA),
                          border: index < appState.sortedWords.length - 1
                              ? const Border(
                                  bottom: BorderSide(color: Color(0xFFE5E5EA)),
                                )
                              : null,
                        ),
                        child: ListTile(
                          dense: true,
                          title: Text(
                            '${index + 1}. $word',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _copyResults(BuildContext context, List<String> words) {
    final text = words.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n');
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Results copied to clipboard')),
    );
  }

  void _exportResults(BuildContext context, List<String> words) {
    final text = words.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n');
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Results exported to clipboard')),
    );
  }
}

