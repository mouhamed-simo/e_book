import 'package:ebook_mvp/screens/book_details_screen.dart';
import 'package:ebook_mvp/screens/reader_screen.dart';
import 'package:ebook_mvp/screens/splash_screen.dart';
import 'package:ebook_mvp/utils/app_colors.dart';
import 'package:ebook_mvp/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/quiz.dart';
import '../services/gemini_service.dart';

import 'package:get/get.dart';

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
      final q = await GeminiService.generateQuiz(
        book: widget.book,
        numQuestions: 5,
      );
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
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
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
      appBar: AppBar(
        title: Text(
          'Quiz',
          style: AppTextStyle.withColor(AppTextStyle.bodyLarge, Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Question ${_current + 1}/${questions.length}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: LinearProgressIndicator(
                value: (_current + 1) / questions.length,
                backgroundColor: Colors.grey.shade300,
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(16),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              q.question,
              style: AppTextStyle.withColor(AppTextStyle.h3, Colors.black),
            ),
            const SizedBox(height: 16),
           
            Column(
              children: q.choices.map((c) {
                final isSelected = _answers[_current] == c;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Colors.orange
                          : Colors.grey[200],
                      foregroundColor: isSelected ? Colors.white : Colors.black,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _answers[_current] = c;
                      });
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        c,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _current > 0
                      ? () => setState(() => _current--)
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(18),
                    ),
                  ),
                  child: Text(
                    'Précédent',
                    style: AppTextStyle.withColor(
                      AppTextStyle.buttonLarge,
                      Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(16),
                    ),
                  ),
                  onPressed: _current < questions.length - 1
                      ? () => setState(() => _current++)
                      : _answers.length == questions.length
                      ? _showResultScreen
                      : null,
                  child: Text(
                    _current < questions.length - 1 ? 'Suivant' : 'Submit',

                    style: AppTextStyle.withColor(
                      AppTextStyle.buttonLarge,
                      Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showResultScreen() {
    final questions = _questions!;
    int correct = 0;
    for (int i = 0; i < questions.length; i++) {
      if (_answers[i] == questions[i].correctAnswer) correct++;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Résultats du Quiz',
              style: AppTextStyle.withColor(AppTextStyle.h1, Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: correct / questions.length,
                          strokeWidth: 10,
                          color: Theme.of(context).primaryColor,
                          backgroundColor: Colors.grey.shade300,
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                          ),
                          child: Center(
                            child: Text(
                              '$correct/${questions.length}',
                              style: AppTextStyle.withColor(
                                AppTextStyle.withWeight(
                                  AppTextStyle.h1,
                                  FontWeight.bold,
                                ),
                                Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 74,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.green.withOpacity(0.1),
                      border: Border.all(color: AppColors.green, width: 1),
                    ),
              
                    child: Row(
                      children: [
                        Icon(
                          Icons.done_outline_rounded,
                          color: AppColors.green,
                          size: 16,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Excellent travail ! Vous avez réussi le quiz.',
              
                            style: AppTextStyle.withColor(
                              AppTextStyle.bodyMeduim,
                              AppColors.green,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (_, i) {
                        final q = questions[i];
                        final userAnswer = _answers[i]!;
                        final correctAnswer = q.correctAnswer;
                        final isCorrect = userAnswer == correctAnswer;
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(
                              q.question,
                              style: AppTextStyle.withColor(
                                AppTextStyle.bodyMeduim,
                                Colors.black,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.greyOpacity,
                                  ),
                                  child: Text(
                                    'Votre réponse: $userAnswer',
                                    style: AppTextStyle.withColor(
                                      AppTextStyle.bodySmall,
                                      AppColors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                if (!isCorrect)
                                  Text(
                                    'Réponse correcte: $correctAnswer',
                                    style: AppTextStyle.withColor(
                                      AppTextStyle.bodySmall,
                                      AppColors.accent,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: Icon(
                              isCorrect
                                  ? Icons.done_rounded
                                  : Icons.close_rounded,
                              color: isCorrect ? AppColors.green : Colors.red,
                            ),
                            
                          ),
                          
                        );
                      },
                      
                    ),
                  ),
              
                  SizedBox(height: 14),
                  ElevatedButton(
                    
                    onPressed: () {
                      setState(() {
                        _current = 0;
                        _answers.clear();
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.refresh, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          'Refaire le Quiz',
                          style: AppTextStyle.withColor(
                            AppTextStyle.buttonMeduim,
                            Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () {
                  
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.book, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          'Retour au Livre',
                          style: AppTextStyle.withColor(
                            AppTextStyle.buttonMeduim,
                            Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
              ),
            ),
          ),
          
        ),
      ),
    );
  }
}
