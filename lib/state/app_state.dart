import 'package:flutter/foundation.dart';
import '../models/lesson.dart';
import '../models/word.dart';
import '../models/quiz_question.dart';

class AppState extends ChangeNotifier {
  final List<Lesson> lessons = [];
  final List<Word> words = [];
  final List<QuizQuestion> quizQuestions = [];

  final Set<String> completedLessonIds = <String>{};
  int? lastQuizScore;

  void loadSampleData() {
    if (lessons.isNotEmpty) return;
    lessons.addAll([
      Lesson(id: 'l1', title: 'Greetings', description: 'Basic greetings and introductions'),
      Lesson(id: 'l2', title: 'Daily Activities', description: 'Talking about daily routines'),
      Lesson(id: 'l3', title: 'Travel', description: 'Vocabulary and phrases for travel'),
    ]);

    words.addAll([
      Word(term: 'Hello', translation: 'Halo', partOfSpeech: 'interjection', example: 'Hello, how are you?'),
      Word(term: 'Book', translation: 'Buku', partOfSpeech: 'noun', example: 'I read a book'),
      Word(term: 'Run', translation: 'Lari', partOfSpeech: 'verb', example: 'He runs every morning'),
      Word(term: 'Quickly', translation: 'Dengan cepat', partOfSpeech: 'adverb', example: 'Finish it quickly'),
      Word(term: 'Beautiful', translation: 'Indah/Cantik', partOfSpeech: 'adjective', example: 'What a beautiful day!'),
    ]);

    quizQuestions.addAll([
      QuizQuestion(
        prompt: 'What is the correct greeting?',
        options: ['Bye', 'Hello', 'Later', 'Go'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'Choose the noun:',
        options: ['Run', 'Quickly', 'Book', 'Beautiful'],
        correctIndex: 2,
      ),
      QuizQuestion(
        prompt: 'Translate "Beautiful" to Indonesian',
        options: ['Buku', 'Indah', 'Lari', 'Halo'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'Which is a verb?',
        options: ['Run', 'Hello', 'Book', 'Quickly'],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'Best phrase to start a conversation?',
        options: ['Goodbye', 'Hello', 'Thanks', 'Beautiful'],
        correctIndex: 1,
      ),
    ]);
  }

  void startLesson(String lessonId) {
    completedLessonIds.add(lessonId);
    notifyListeners();
  }

  void finishQuiz(int score) {
    lastQuizScore = score;
    notifyListeners();
  }
}