class Lesson {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String difficulty;
  final int duration;
  final List<String> content;

  Lesson({
    required this.id, 
    required this.title, 
    required this.description,
    this.isCompleted = false, // Default value false
    String? difficulty,
    int? duration,
    List<String>? content,
  }) : difficulty = difficulty ?? 'Beginner', // Default difficulty
       duration = duration ?? 30, // Default duration in minutes
       content = content ?? ['Introduction', 'Practice', 'Review']; // Default content topics
}