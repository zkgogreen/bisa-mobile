class QuizQuestion {
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String type;
  final String question;

  QuizQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    this.type = 'Multiple Choice', // Default type
    String? question, // Optional parameter
  }) : question = question ?? prompt; // Use prompt as question if not provided

  // Getter untuk mendapatkan jawaban yang benar
  String get correctAnswer => options[correctIndex];
}