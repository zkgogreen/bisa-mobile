import '../models/course.dart';

// Data dummy untuk testing sistem courses
class CourseData {
  static List<Course> getAllCourses() {
    return [
      Course(
        id: 'course_1',
        title: 'English Grammar Fundamentals',
        description: 'Pelajari dasar-dasar tata bahasa Inggris dengan mudah dan menyenangkan. Course ini cocok untuk pemula yang ingin memahami struktur kalimat, tenses, dan aturan grammar dasar.',
        imageUrl: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400',
        category: 'Grammar',
        level: 'Beginner',
        totalModules: 3,
        totalLessons: 12,
        estimatedHours: 8,
        progress: 0.3,
        isEnrolled: true,
        enrolledDate: DateTime.now().subtract(const Duration(days: 5)),
        modules: [
          Module(
            id: 'module_1_1',
            courseId: 'course_1',
            title: 'Basic Sentence Structure',
            description: 'Memahami struktur dasar kalimat bahasa Inggris',
            order: 1,
            isUnlocked: true,
            lessons: [
              CourseLesson(
                id: 'lesson_1_1_1',
                moduleId: 'module_1_1',
                title: 'Subject and Predicate',
                content: 'Dalam bahasa Inggris, setiap kalimat memiliki dua bagian utama: Subject (subjek) dan Predicate (predikat)...',
                type: 'text',
                order: 1,
                estimatedMinutes: 15,
                isUnlocked: true,
                isCompleted: true,
                completedDate: DateTime.now().subtract(const Duration(days: 3)),
              ),
              CourseLesson(
                id: 'lesson_1_1_2',
                moduleId: 'module_1_1',
                title: 'Types of Sentences',
                content: 'Ada empat jenis kalimat dalam bahasa Inggris: Declarative, Interrogative, Imperative, dan Exclamatory...',
                type: 'interactive',
                order: 2,
                estimatedMinutes: 20,
                isUnlocked: true,
                isCompleted: true,
                completedDate: DateTime.now().subtract(const Duration(days: 2)),
              ),
              CourseLesson(
                id: 'lesson_1_1_3',
                moduleId: 'module_1_1',
                title: 'Word Order',
                content: 'Urutan kata dalam bahasa Inggris mengikuti pola Subject-Verb-Object (SVO)...',
                type: 'video',
                order: 3,
                estimatedMinutes: 25,
                videoUrl: 'https://example.com/video1',
                isUnlocked: true,
              ),
              CourseLesson(
                id: 'lesson_1_1_4',
                moduleId: 'module_1_1',
                title: 'Practice Exercises',
                content: 'Latihan soal untuk menguji pemahaman tentang struktur kalimat dasar...',
                type: 'exercise',
                order: 4,
                estimatedMinutes: 30,
                isUnlocked: true,
              ),
            ],
            summary: ModuleSummary(
              id: 'summary_1_1',
              moduleId: 'module_1_1',
              title: 'Ringkasan: Basic Sentence Structure',
              content: 'Dalam modul ini, kita telah mempelajari struktur dasar kalimat bahasa Inggris...',
              keyPoints: [
                'Setiap kalimat memiliki Subject dan Predicate',
                'Ada 4 jenis kalimat: Declarative, Interrogative, Imperative, Exclamatory',
                'Urutan kata mengikuti pola SVO (Subject-Verb-Object)',
                'Pemahaman struktur kalimat adalah fondasi grammar yang kuat'
              ],
              nextSteps: [
                'Lanjutkan ke modul Parts of Speech',
                'Praktikkan membuat kalimat dengan struktur yang benar',
                'Kerjakan latihan tambahan di bagian exercise'
              ],
              estimatedMinutes: 10,
            ),
            quiz: ModuleQuiz(
              id: 'quiz_1_1',
              moduleId: 'module_1_1',
              title: 'Quiz: Basic Sentence Structure',
              description: 'Test pemahaman Anda tentang struktur kalimat dasar',
              passingScore: 70,
              timeLimit: 15,
              questions: [
                QuizQuestion(
                  id: 'q_1_1_1',
                  question: 'What are the two main parts of a sentence?',
                  options: ['Subject and Object', 'Subject and Predicate', 'Verb and Object', 'Noun and Verb'],
                  correctAnswerIndex: 1,
                  explanation: 'Every sentence has a subject (who or what) and a predicate (what the subject does).',
                  points: 10,
                ),
                QuizQuestion(
                  id: 'q_1_1_2',
                  question: 'Which sentence type asks a question?',
                  options: ['Declarative', 'Interrogative', 'Imperative', 'Exclamatory'],
                  correctAnswerIndex: 1,
                  explanation: 'Interrogative sentences are used to ask questions.',
                  points: 10,
                ),
              ],
            ),
          ),
          Module(
            id: 'module_1_2',
            courseId: 'course_1',
            title: 'Parts of Speech',
            description: 'Mengenal jenis-jenis kata dalam bahasa Inggris',
            order: 2,
            isUnlocked: true,
            lessons: [
              CourseLesson(
                id: 'lesson_1_2_1',
                moduleId: 'module_1_2',
                title: 'Nouns',
                content: 'Noun adalah kata benda yang menyebutkan nama orang, tempat, benda, atau ide...',
                type: 'text',
                order: 1,
                estimatedMinutes: 20,
                isUnlocked: true,
              ),
              CourseLesson(
                id: 'lesson_1_2_2',
                moduleId: 'module_1_2',
                title: 'Verbs',
                content: 'Verb adalah kata kerja yang menunjukkan aksi atau keadaan...',
                type: 'video',
                order: 2,
                estimatedMinutes: 25,
                videoUrl: 'https://example.com/video2',
                isUnlocked: true,
              ),
              CourseLesson(
                id: 'lesson_1_2_3',
                moduleId: 'module_1_2',
                title: 'Adjectives and Adverbs',
                content: 'Adjective mendeskripsikan noun, sedangkan adverb mendeskripsikan verb...',
                type: 'interactive',
                order: 3,
                estimatedMinutes: 30,
                isUnlocked: false,
              ),
            ],
            summary: ModuleSummary(
              id: 'summary_1_2',
              moduleId: 'module_1_2',
              title: 'Ringkasan: Parts of Speech',
              content: 'Parts of speech adalah klasifikasi kata berdasarkan fungsinya dalam kalimat...',
              keyPoints: [
                'Noun: kata benda (person, place, thing, idea)',
                'Verb: kata kerja (action or state)',
                'Adjective: kata sifat (describes nouns)',
                'Adverb: kata keterangan (describes verbs, adjectives, other adverbs)'
              ],
              nextSteps: [
                'Lanjutkan ke modul Verb Tenses',
                'Identifikasi parts of speech dalam kalimat',
                'Praktikkan penggunaan adjective dan adverb'
              ],
              estimatedMinutes: 12,
            ),
            quiz: ModuleQuiz(
              id: 'quiz_1_2',
              moduleId: 'module_1_2',
              title: 'Quiz: Parts of Speech',
              description: 'Test pemahaman Anda tentang jenis-jenis kata',
              passingScore: 70,
              timeLimit: 20,
              questions: [
                QuizQuestion(
                  id: 'q_1_2_1',
                  question: 'Which part of speech describes a noun?',
                  options: ['Verb', 'Adjective', 'Adverb', 'Preposition'],
                  correctAnswerIndex: 1,
                  explanation: 'Adjectives are used to describe or modify nouns.',
                  points: 10,
                ),
              ],
            ),
          ),
          Module(
            id: 'module_1_3',
            courseId: 'course_1',
            title: 'Basic Tenses',
            description: 'Memahami tenses dasar dalam bahasa Inggris',
            order: 3,
            isUnlocked: false,
            lessons: [
              CourseLesson(
                id: 'lesson_1_3_1',
                moduleId: 'module_1_3',
                title: 'Present Tense',
                content: 'Present tense digunakan untuk menyatakan kegiatan yang terjadi saat ini...',
                type: 'text',
                order: 1,
                estimatedMinutes: 25,
                isUnlocked: false,
              ),
              CourseLesson(
                id: 'lesson_1_3_2',
                moduleId: 'module_1_3',
                title: 'Past Tense',
                content: 'Past tense digunakan untuk menyatakan kegiatan yang terjadi di masa lalu...',
                type: 'video',
                order: 2,
                estimatedMinutes: 30,
                videoUrl: 'https://example.com/video3',
                isUnlocked: false,
              ),
            ],
            summary: ModuleSummary(
              id: 'summary_1_3',
              moduleId: 'module_1_3',
              title: 'Ringkasan: Basic Tenses',
              content: 'Tenses menunjukkan waktu terjadinya suatu peristiwa...',
              keyPoints: [
                'Present tense: untuk kejadian saat ini',
                'Past tense: untuk kejadian masa lalu',
                'Future tense: untuk kejadian masa depan'
              ],
              nextSteps: [
                'Selesaikan course English Grammar Fundamentals',
                'Praktikkan penggunaan tenses dalam percakapan',
                'Lanjutkan ke course Advanced English Conversation'
              ],
              estimatedMinutes: 8,
            ),
            quiz: ModuleQuiz(
              id: 'quiz_1_3',
              moduleId: 'module_1_3',
              title: 'Quiz: Basic Tenses',
              description: 'Test pemahaman Anda tentang tenses dasar',
              passingScore: 70,
              timeLimit: 25,
              questions: [
                QuizQuestion(
                  id: 'q_1_3_1',
                  question: 'Which tense is used for actions happening now?',
                  options: ['Past tense', 'Present tense', 'Future tense', 'Perfect tense'],
                  correctAnswerIndex: 1,
                  explanation: 'Present tense is used for actions happening now or general truths.',
                  points: 10,
                ),
              ],
            ),
          ),
        ],
      ),
      Course(
        id: 'course_2',
        title: 'Advanced English Conversation',
        description: 'Tingkatkan kemampuan berbicara bahasa Inggris Anda dengan teknik percakapan lanjutan, idiom, dan ekspresi sehari-hari.',
        imageUrl: 'https://images.unsplash.com/photo-1577563908411-5077b6dc7624?w=400',
        category: 'Speaking',
        level: 'Advanced',
        totalModules: 4,
        totalLessons: 16,
        estimatedHours: 12,
        progress: 0.0,
        isEnrolled: false,
        modules: [
          Module(
            id: 'module_2_1',
            courseId: 'course_2',
            title: 'Everyday Conversations',
            description: 'Percakapan sehari-hari dalam berbagai situasi',
            order: 1,
            isUnlocked: false,
            lessons: [
              CourseLesson(
                id: 'lesson_2_1_1',
                moduleId: 'module_2_1',
                title: 'Greetings and Introductions',
                content: 'Cara menyapa dan memperkenalkan diri dalam berbagai situasi formal dan informal...',
                type: 'video',
                order: 1,
                estimatedMinutes: 20,
                videoUrl: 'https://example.com/video4',
                isUnlocked: false,
              ),
            ],
            summary: ModuleSummary(
              id: 'summary_2_1',
              moduleId: 'module_2_1',
              title: 'Ringkasan: Everyday Conversations',
              content: 'Percakapan sehari-hari adalah kunci untuk berkomunikasi efektif...',
              keyPoints: [
                'Greeting yang tepat sesuai situasi',
                'Self-introduction yang natural',
                'Small talk untuk membangun rapport'
              ],
              nextSteps: [
                'Lanjutkan ke modul Business Presentations',
                'Praktikkan conversation dengan native speaker',
                'Record diri sendiri untuk evaluasi pronunciation'
              ],
              estimatedMinutes: 15,
            ),
            quiz: ModuleQuiz(
              id: 'quiz_2_1',
              moduleId: 'module_2_1',
              title: 'Quiz: Everyday Conversations',
              description: 'Test kemampuan percakapan sehari-hari Anda',
              passingScore: 75,
              timeLimit: 20,
              questions: [
                QuizQuestion(
                  id: 'q_2_1_1',
                  question: 'What is an appropriate response to "How are you?"',
                  options: ['I am fine, thank you', 'Yes, please', 'No problem', 'You are welcome'],
                  correctAnswerIndex: 0,
                  explanation: '"I am fine, thank you" is the standard polite response to "How are you?"',
                  points: 10,
                ),
              ],
            ),
          ),
        ],
      ),
      Course(
        id: 'course_3',
        title: 'Business English Essentials',
        description: 'Kuasai bahasa Inggris untuk dunia kerja, termasuk email bisnis, presentasi, dan meeting.',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        category: 'Business',
        level: 'Intermediate',
        totalModules: 5,
        totalLessons: 20,
        estimatedHours: 15,
        progress: 0.0,
        isEnrolled: false,
        modules: [
          Module(
            id: 'module_3_1',
            courseId: 'course_3',
            title: 'Professional Communication',
            description: 'Komunikasi profesional dalam dunia kerja',
            order: 1,
            isUnlocked: false,
            lessons: [
              CourseLesson(
                id: 'lesson_3_1_1',
                moduleId: 'module_3_1',
                title: 'Writing Professional Emails',
                content: 'Cara menulis email bisnis yang efektif dan profesional...',
                type: 'text',
                order: 1,
                estimatedMinutes: 30,
                isUnlocked: false,
              ),
            ],
            summary: ModuleSummary(
              id: 'summary_3_1',
              moduleId: 'module_3_1',
              title: 'Ringkasan: Professional Communication',
              content: 'Komunikasi profesional adalah kunci sukses di dunia kerja...',
              keyPoints: [
                'Email yang clear dan concise',
                'Tone yang professional namun friendly',
                'Structure yang mudah dipahami'
              ],
              nextSteps: [
                'Selesaikan course Business English Essentials',
                'Praktikkan menulis email dengan kolega',
                'Join business English conversation group'
              ],
              estimatedMinutes: 20,
            ),
            quiz: ModuleQuiz(
              id: 'quiz_3_1',
              moduleId: 'module_3_1',
              title: 'Quiz: Professional Communication',
              description: 'Test kemampuan komunikasi profesional Anda',
              passingScore: 80,
              timeLimit: 25,
              questions: [
                QuizQuestion(
                  id: 'q_3_1_1',
                  question: 'What is the best way to start a formal email?',
                  options: ['Hey there!', 'Dear Sir/Madam', 'Whats up?', 'Hello friend'],
                  correctAnswerIndex: 1,
                  explanation: '"Dear Sir/Madam" is the most appropriate formal email greeting.',
                  points: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  // Method untuk mendapatkan course berdasarkan ID
  static Course? getCourseById(String courseId) {
    try {
      return getAllCourses().firstWhere((course) => course.id == courseId);
    } catch (e) {
      return null;
    }
  }

  // Method untuk mendapatkan enrolled courses
  static List<Course> getEnrolledCourses() {
    return getAllCourses().where((course) => course.isEnrolled).toList();
  }

  // Method untuk mendapatkan courses berdasarkan kategori
  static List<Course> getCoursesByCategory(String category) {
    return getAllCourses().where((course) => course.category == category).toList();
  }

  // Method untuk mendapatkan courses berdasarkan level
  static List<Course> getCoursesByLevel(String level) {
    return getAllCourses().where((course) => course.level == level).toList();
  }
}