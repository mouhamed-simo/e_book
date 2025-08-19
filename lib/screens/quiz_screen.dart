import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/quiz.dart';
import '../services/gemini_service.dart';

class QuizScreen extends StatefulWidget {
  final Book book;
  const QuizScreen({super.key, required this.book});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuizQuestion>? _questions;
  int _current = 0;
  final Map<int, String> _answers = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final q = await GeminiService.generateQuiz(book: widget.book, numQuestions: 5);
      setState(() {
        _questions = q;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load quiz';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: Center(child: Text(_error!)),
      );
    }
    final questions = _questions!;
    final q = questions[_current];

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Question ${_current + 1}/${questions.length}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(q.question, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...q.choices.map((c) => RadioListTile<String>(
                  value: c,
                  groupValue: _answers[_current],
                  title: Text(c),
                  onChanged: (v) => setState(() => _answers[_current] = v!),
                )),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _current > 0 ? () => setState(() => _current--) : null,
                  child: const Text('Back'),
                ),
                FilledButton(
                  onPressed: _current < questions.length - 1
                      ? () => setState(() => _current++)
                      : _answers.length == questions.length
                          ? _showResult
                          : null,
                  child: Text(_current < questions.length - 1 ? 'Next' : 'Submit'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showResult() {
    final questions = _questions!;
    int correct = 0;
    for (int i = 0; i < questions.length; i++) {
      if (_answers[i] == questions[i].correctAnswer) correct++;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Results'),
        content: Text('You scored $correct / ${questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _current = 0;
                _answers.clear();
              });
            },
            child: const Text('Retry'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}