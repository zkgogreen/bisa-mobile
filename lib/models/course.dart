// Model untuk Course dalam sistem pembelajaran
class Course {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String level; // Beginner, Intermediate, Advanced
  final int totalModules;
  final int totalLessons;
  final int estimatedHours;
  final List<Module> modules;
  final double progress; // 0.0 - 1.0
  final bool isEnrolled;
  final bool isCompleted;
  final DateTime? enrolledDate;
  final DateTime? completedDate;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.level,
    required this.totalModules,
    required this.totalLessons,
    required this.estimatedHours,
    required this.modules,
    this.progress = 0.0,
    this.isEnrolled = false,
    this.isCompleted = false,
    this.enrolledDate,
    this.completedDate,
  });

  // Method untuk mendapatkan module berdasarkan ID
  Module? getModuleById(String moduleId) {
    try {
      return modules.firstWhere((module) => module.id == moduleId);
    } catch (e) {
      return null;
    }
  }

  // Method untuk mendapatkan lesson berdasarkan ID
  CourseLesson? getLessonById(String lessonId) {
    for (var module in modules) {
      try {
        return module.lessons.firstWhere((lesson) => lesson.id == lessonId);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  // Method untuk menghitung progress berdasarkan lesson yang selesai
  double calculateProgress() {
    if (totalLessons == 0) return 0.0;
    
    int completedLessons = 0;
    for (var module in modules) {
      completedLessons += module.lessons.where((lesson) => lesson.isCompleted).length;
    }
    
    return completedLessons / totalLessons;
  }

  // Copy with method untuk update
  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? category,
    String? level,
    int? totalModules,
    int? totalLessons,
    int? estimatedHours,
    List<Module>? modules,
    double? progress,
    bool? isEnrolled,
    bool? isCompleted,
    DateTime? enrolledDate,
    DateTime? completedDate,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      level: level ?? this.level,
      totalModules: totalModules ?? this.totalModules,
      totalLessons: totalLessons ?? this.totalLessons,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      modules: modules ?? this.modules,
      progress: progress ?? this.progress,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      isCompleted: isCompleted ?? this.isCompleted,
      enrolledDate: enrolledDate ?? this.enrolledDate,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}

// Model untuk Module dalam Course
class Module {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final int order;
  final List<CourseLesson> lessons;
  final ModuleSummary summary;
  final ModuleQuiz quiz;
  final bool isUnlocked;
  final bool isCompleted;
  final DateTime? completedDate;

  Module({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.order,
    required this.lessons,
    required this.summary,
    required this.quiz,
    this.isUnlocked = false,
    this.isCompleted = false,
    this.completedDate,
  });

  // Method untuk menghitung progress module
  double calculateProgress() {
    if (lessons.isEmpty) return 0.0;
    
    int completedLessons = lessons.where((lesson) => lesson.isCompleted).length;
    double lessonProgress = completedLessons / lessons.length;
    
    // Tambahkan progress summary dan quiz jika sudah selesai
    double summaryProgress = summary.isCompleted ? 0.1 : 0.0;
    double quizProgress = quiz.isCompleted ? 0.1 : 0.0;
    
    return (lessonProgress * 0.8) + summaryProgress + quizProgress;
  }

  // Copy with method
  Module copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    int? order,
    List<CourseLesson>? lessons,
    ModuleSummary? summary,
    ModuleQuiz? quiz,
    bool? isUnlocked,
    bool? isCompleted,
    DateTime? completedDate,
  }) {
    return Module(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      lessons: lessons ?? this.lessons,
      summary: summary ?? this.summary,
      quiz: quiz ?? this.quiz,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}

// Model untuk Lesson dalam Module
class CourseLesson {
  final String id;
  final String moduleId;
  final String title;
  final String content;
  final String type; // video, text, interactive, exercise
  final int order;
  final int estimatedMinutes;
  final String? videoUrl;
  final List<String>? attachments;
  final bool isCompleted;
  final bool isUnlocked;
  final DateTime? completedDate;
  final int? score; // untuk lesson yang ada quiz-nya

  CourseLesson({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.content,
    required this.type,
    required this.order,
    required this.estimatedMinutes,
    this.videoUrl,
    this.attachments,
    this.isCompleted = false,
    this.isUnlocked = false,
    this.completedDate,
    this.score,
  });

  // Copy with method
  CourseLesson copyWith({
    String? id,
    String? moduleId,
    String? title,
    String? content,
    String? type,
    int? order,
    int? estimatedMinutes,
    String? videoUrl,
    List<String>? attachments,
    bool? isCompleted,
    bool? isUnlocked,
    DateTime? completedDate,
    int? score,
  }) {
    return CourseLesson(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      order: order ?? this.order,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      videoUrl: videoUrl ?? this.videoUrl,
      attachments: attachments ?? this.attachments,
      isCompleted: isCompleted ?? this.isCompleted,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      completedDate: completedDate ?? this.completedDate,
      score: score ?? this.score,
    );
  }
}

// Model untuk Summary dalam Module
class ModuleSummary {
  final String id;
  final String moduleId;
  final String title;
  final String content;
  final List<String> keyPoints;
  final List<String> nextSteps;
  final int estimatedMinutes;
  final bool isCompleted;
  final DateTime? completedDate;

  ModuleSummary({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.content,
    required this.keyPoints,
    required this.nextSteps,
    required this.estimatedMinutes,
    this.isCompleted = false,
    this.completedDate,
  });

  ModuleSummary copyWith({
    String? id,
    String? moduleId,
    String? title,
    String? content,
    List<String>? keyPoints,
    List<String>? nextSteps,
    int? estimatedMinutes,
    bool? isCompleted,
    DateTime? completedDate,
  }) {
    return ModuleSummary(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      content: content ?? this.content,
      keyPoints: keyPoints ?? this.keyPoints,
      nextSteps: nextSteps ?? this.nextSteps,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}

// Model untuk Quiz dalam Module
class ModuleQuiz {
  final String id;
  final String moduleId;
  final String title;
  final String description;
  final List<QuizQuestion> questions;
  final int passingScore;
  final int timeLimit; // dalam menit
  final bool isCompleted;
  final int? score;
  final int? attempts;
  final DateTime? completedDate;

  ModuleQuiz({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.description,
    required this.questions,
    required this.passingScore,
    required this.timeLimit,
    this.isCompleted = false,
    this.score,
    this.attempts = 0,
    this.completedDate,
  });

  bool get isPassed => score != null && score! >= passingScore;

  ModuleQuiz copyWith({
    String? id,
    String? moduleId,
    String? title,
    String? description,
    List<QuizQuestion>? questions,
    int? passingScore,
    int? timeLimit,
    bool? isCompleted,
    int? score,
    int? attempts,
    DateTime? completedDate,
  }) {
    return ModuleQuiz(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      description: description ?? this.description,
      questions: questions ?? this.questions,
      passingScore: passingScore ?? this.passingScore,
      timeLimit: timeLimit ?? this.timeLimit,
      isCompleted: isCompleted ?? this.isCompleted,
      score: score ?? this.score,
      attempts: attempts ?? this.attempts,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}

// Model untuk Question dalam Quiz
class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final int points;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.points = 1,
  });

  // Getter untuk mendapatkan jawaban yang benar
  String get correctAnswer {
    if (correctAnswerIndex >= 0 && correctAnswerIndex < options.length) {
      return options[correctAnswerIndex];
    }
    return '';
  }
}