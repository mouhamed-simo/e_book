import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/book.dart';
import '../models/quiz.dart';

class GeminiService {
  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  static final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);

  static Future<List<QuizQuestion>> generateQuiz({required Book book, int numQuestions = 5}) async {
    final prompt = '''
Generate exactly $numQuestions multiple-choice questions about this book.
Return ONLY valid JSON (no code fences, no prose), array of objects with keys: question (string), choices (array of 4 strings), correctAnswer (one of the choices).
Title: ${book.title}
Summary: ${book.summary}
JSON:
''';

    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text?.trim();
    if (text == null || text.isEmpty) {
      throw Exception('Empty quiz response from Gemini');
    }

    // Attempt to locate JSON in response safely
    final cleaned = _extractJsonArray(text);
    final List<dynamic> data = jsonDecode(cleaned);
    return data.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String _extractJsonArray(String input) {
    final start = input.indexOf('[');
    final end = input.lastIndexOf(']');
    if (start == -1 || end == -1 || end < start) return input;
    return input.substring(start, end + 1);
  }
}