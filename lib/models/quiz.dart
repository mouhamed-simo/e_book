class QuizQuestion {
  final String question;
  final List<String> choices;
  final String correctAnswer;

  QuizQuestion({
    required this.question,
    required this.choices,
    required this.correctAnswer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> j) => QuizQuestion(
        question: j['question'] as String,
        choices: (j['choices'] as List).map((e) => e.toString()).toList(),
        correctAnswer: j['correctAnswer'] as String,
      );
}