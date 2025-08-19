import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/book.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;
  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book.coverUrl != null)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(book.coverUrl!, fit: BoxFit.cover),
                ),
              ),
            const SizedBox(height: 16),
            Text(book.title, style: Theme.of(context).textTheme.headlineSmall),
            if (book.author != null) Text('by ${book.author!}', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            Text(book.summary),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: book.ebookUrl == null
                      ? null
                      : () => context.go('/reader?url=${Uri.encodeComponent(book.ebookUrl!)}'),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Read Book'),
                ),
                ElevatedButton.icon(
                  onPressed: book.audioUrl == null
                      ? null
                      : () => context.go('/audio?url=${Uri.encodeComponent(book.audioUrl!)}&title=${Uri.encodeComponent(book.title)}'),
                  icon: const Icon(Icons.headphones),
                  label: const Text('Listen'),
                ),
                FilledButton.icon(
                  onPressed: () => context.go('/quiz', extra: book),
                  icon: const Icon(Icons.quiz_outlined),
                  label: const Text('Take Quiz'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}