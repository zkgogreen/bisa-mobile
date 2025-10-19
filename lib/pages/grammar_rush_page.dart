import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../widgets/app_brand_icon.dart';

// Model untuk soal Grammar Rush
class GrammarQuestion {
  final String incorrectSentence;
  final String correctSentence;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String grammarRule;
  final String category;

  GrammarQuestion({
    required this.incorrectSentence,
    required this.correctSentence,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.grammarRule,
    required this.category,
  });
}

// Model untuk materi grammar
class GrammarTopic {
  final String title;
  final String description;
  final List<String> rules;
  final List<String> examples;
  final IconData icon;

  GrammarTopic({
    required this.title,
    required this.description,
    required this.rules,
    required this.examples,
    required this.icon,
  });
}

class GrammarRushPage extends StatefulWidget {
  const GrammarRushPage({super.key});

  @override
  State<GrammarRushPage> createState() => _GrammarRushPageState();
}

class _GrammarRushPageState extends State<GrammarRushPage>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _timerAnimationController;
  late AnimationController _scoreAnimationController;
  late AnimationController _questionAnimationController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _questionAnimation;

  // Game state
  int currentQuestionIndex = 0;
  int score = 0;
  int correctAnswers = 0;
  int timeLeft = 60; // 60 detik per game
  bool gameActive = false;
  bool gameCompleted = false;
  Timer? gameTimer;
  int? selectedAnswerIndex;
  bool showExplanation = false;
  bool showTutorial = false;
  bool showMaterials = false;

  // Data soal grammar
  List<GrammarQuestion> questions = [
    GrammarQuestion(
      incorrectSentence: "She don't like coffee.",
      correctSentence: "She doesn't like coffee.",
      options: ["don't", "doesn't", "didn't", "won't"],
      correctAnswerIndex: 1,
      explanation: "Use 'doesn't' with third person singular (he, she, it)",
      grammarRule: "Third person singular subjects (he, she, it) use 'doesn't' for negative present tense",
      category: "Subject-Verb Agreement",
    ),
    GrammarQuestion(
      incorrectSentence: "I have went to the store.",
      correctSentence: "I have gone to the store.",
      options: ["went", "gone", "go", "going"],
      correctAnswerIndex: 1,
      explanation: "Use 'gone' with present perfect tense (have/has + past participle)",
      grammarRule: "Present perfect tense: have/has + past participle (gone, not went)",
      category: "Perfect Tenses",
    ),
    GrammarQuestion(
      incorrectSentence: "There is many books on the table.",
      correctSentence: "There are many books on the table.",
      options: ["is", "are", "was", "were"],
      correctAnswerIndex: 1,
      explanation: "Use 'are' with plural nouns (books)",
      grammarRule: "There + be: Use 'are' with plural nouns, 'is' with singular nouns",
      category: "Subject-Verb Agreement",
    ),
    GrammarQuestion(
      incorrectSentence: "He can sings very well.",
      correctSentence: "He can sing very well.",
      options: ["sings", "sing", "singing", "sang"],
      correctAnswerIndex: 1,
      explanation: "After modal verbs (can, will, must), use base form of verb",
      grammarRule: "Modal verbs + base form: can/will/must/should + verb (without -s, -ing, -ed)",
      category: "Modal Verbs",
    ),
    GrammarQuestion(
      incorrectSentence: "I am more better than him.",
      correctSentence: "I am better than him.",
      options: ["more better", "better", "most better", "best"],
      correctAnswerIndex: 1,
      explanation: "'Better' is already comparative form, don't add 'more'",
      grammarRule: "Irregular comparatives: good → better → best (don't use 'more' or 'most')",
      category: "Comparatives",
    ),
    GrammarQuestion(
      incorrectSentence: "She have a beautiful car.",
      correctSentence: "She has a beautiful car.",
      options: ["have", "has", "had", "having"],
      correctAnswerIndex: 1,
      explanation: "Use 'has' with third person singular (he, she, it)",
      grammarRule: "Present tense 'have': I/you/we/they have, he/she/it has",
      category: "Subject-Verb Agreement",
    ),
    GrammarQuestion(
      incorrectSentence: "I didn't went to school yesterday.",
      correctSentence: "I didn't go to school yesterday.",
      options: ["went", "go", "gone", "going"],
      correctAnswerIndex: 1,
      explanation: "After 'didn't', use base form of verb (go, not went)",
      grammarRule: "Negative past: didn't + base form (didn't go, didn't eat, didn't see)",
      category: "Past Tense",
    ),
    GrammarQuestion(
      incorrectSentence: "Each student have their own book.",
      correctSentence: "Each student has their own book.",
      options: ["have", "has", "had", "having"],
      correctAnswerIndex: 1,
      explanation: "'Each' is singular, so use 'has'",
      grammarRule: "Singular subjects: each, every, everyone, someone + singular verb",
      category: "Subject-Verb Agreement",
    ),
  ];

  // Data materi grammar
  List<GrammarTopic> grammarTopics = [
    GrammarTopic(
      title: "Subject-Verb Agreement",
      description: "Kesesuaian antara subjek dan kata kerja dalam kalimat",
      icon: Icons.people,
      rules: [
        "Subjek tunggal + kata kerja tunggal (He works)",
        "Subjek jamak + kata kerja jamak (They work)",
        "Third person singular: he/she/it + verb+s",
        "I/you/we/they + verb tanpa s"
      ],
      examples: [
        "✓ She works hard every day",
        "✗ She work hard every day",
        "✓ They have many books",
        "✗ They has many books"
      ],
    ),
    GrammarTopic(
      title: "Perfect Tenses",
      description: "Penggunaan have/has + past participle",
      icon: Icons.schedule,
      rules: [
        "Present Perfect: have/has + past participle",
        "Past Perfect: had + past participle",
        "Future Perfect: will have + past participle",
        "Gunakan untuk aksi yang sudah selesai"
      ],
      examples: [
        "✓ I have finished my homework",
        "✗ I have finish my homework",
        "✓ She has gone to the market",
        "✗ She has went to the market"
      ],
    ),
    GrammarTopic(
      title: "Modal Verbs",
      description: "Kata kerja bantu: can, will, must, should",
      icon: Icons.help_outline,
      rules: [
        "Modal + base form verb",
        "Tidak ada -s untuk third person",
        "Tidak ada -ing atau -ed",
        "Untuk kemampuan, kemungkinan, keharusan"
      ],
      examples: [
        "✓ He can swim very well",
        "✗ He can swims very well",
        "✓ You should study harder",
        "✗ You should studying harder"
      ],
    ),
    GrammarTopic(
      title: "Past Tense",
      description: "Bentuk lampau untuk menyatakan kejadian di masa lalu",
      icon: Icons.history,
      rules: [
        "Regular verbs: verb + ed",
        "Irregular verbs: go→went, see→saw",
        "Negative: didn't + base form",
        "Question: Did + subject + base form?"
      ],
      examples: [
        "✓ I didn't go to school yesterday",
        "✗ I didn't went to school yesterday",
        "✓ Did you see the movie?",
        "✗ Did you saw the movie?"
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // Setup animasi
    _timerAnimationController = AnimationController(
      duration: Duration(seconds: timeLeft),
      vsync: this,
    );
    
    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _questionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _scoreAnimationController, curve: Curves.elasticOut),
    );
    
    _questionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _questionAnimationController, curve: Curves.easeInOut),
    );

    // Shuffle questions
    questions.shuffle();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    _timerAnimationController.dispose();
    _scoreAnimationController.dispose();
    _questionAnimationController.dispose();
    super.dispose();
  }

  // Mulai game
  void _startGame() {
    setState(() {
      gameActive = true;
      gameCompleted = false;
      currentQuestionIndex = 0;
      score = 0;
      correctAnswers = 0;
      timeLeft = 60;
      selectedAnswerIndex = null;
      showExplanation = false;
    });

    // Start timer
    _timerAnimationController.forward();
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
      });
      
      if (timeLeft <= 0) {
        _endGame();
      }
    });

    // Animate first question
    _questionAnimationController.forward();
  }

  // Akhiri game
  void _endGame() {
    gameTimer?.cancel();
    setState(() {
      gameActive = false;
      gameCompleted = true;
    });
    _showResultDialog();
  }

  // Handle jawaban
  void _selectAnswer(int answerIndex) {
    if (!gameActive || selectedAnswerIndex != null) return;

    setState(() {
      selectedAnswerIndex = answerIndex;
      showExplanation = true;
    });

    final isCorrect = answerIndex == questions[currentQuestionIndex].correctAnswerIndex;
    
    if (isCorrect) {
      setState(() {
        score += 15;
        correctAnswers++;
      });
      
      // Animate score
      _scoreAnimationController.forward().then((_) {
        _scoreAnimationController.reverse();
      });
    }

    // Tunggu sebentar untuk menampilkan penjelasan
    Timer(const Duration(seconds: 2), () {
      _nextQuestion();
    });
  }

  // Pertanyaan selanjutnya
  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        showExplanation = false;
      });
      
      // Animate question transition
      _questionAnimationController.reset();
      _questionAnimationController.forward();
    } else {
      _endGame();
    }
  }

  // Dialog hasil
  void _showResultDialog() {
    final percentage = (correctAnswers / questions.length * 100).round();
    String grade = '';
    Color gradeColor = Colors.grey;
    
    if (percentage >= 90) {
      grade = 'Excellent! 🌟';
      gradeColor = Colors.green;
    } else if (percentage >= 70) {
      grade = 'Good Job! 👍';
      gradeColor = Colors.blue;
    } else if (percentage >= 50) {
      grade = 'Keep Trying! 💪';
      gradeColor = Colors.orange;
    } else {
      grade = 'Practice More! 📚';
      gradeColor = Colors.red;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(grade),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Time\'s up! Here are your results:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: gradeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: gradeColor),
              ),
              child: Column(
                children: [
                  Text(
                    'Score: $score XP',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: gradeColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Correct: $correctAnswers/${questions.length}'),
                  Text('Accuracy: $percentage%'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('Play Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/lessons');
            },
            child: const Text('Back to Lessons'),
          ),
        ],
      ),
    );
  }

  // Reset game
  void _resetGame() {
    gameTimer?.cancel();
    _timerAnimationController.reset();
    _questionAnimationController.reset();
    
    setState(() {
      gameActive = false;
      gameCompleted = false;
      currentQuestionIndex = 0;
      score = 0;
      correctAnswers = 0;
      timeLeft = 60;
      selectedAnswerIndex = null;
      showExplanation = false;
    });
    
    questions.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Grammar Rush',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/lessons'),
        ),
        actions: [
          if (gameActive) ...[
            // Timer
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: timeLeft <= 10 ? Colors.red : Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '⏰ ${timeLeft}s',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Score
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: AnimatedBuilder(
                  animation: _scoreAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scoreAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$score XP',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: showTutorial
            ? _buildTutorialScreen()
            : showMaterials
                ? _buildMaterialsScreen()
                : !gameActive && !gameCompleted
                    ? _buildStartScreen()
                    : _buildGameScreen(),
      ),
    );
  }

  // Layar mulai game
  Widget _buildStartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade100, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  '⚡ Grammar Rush',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Fix grammar mistakes as fast as you can!',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Game Rules:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('• You have 60 seconds'),
                      const Text('• Choose the correct word'),
                      const Text('• +15 XP for each correct answer'),
                      const Text('• Read explanations to learn'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Start Game',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          showTutorial = true;
                        });
                      },
                      icon: const AppBrandIcon(size: 24, color: Colors.blue),
                      label: const Text('Tutorial'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          showMaterials = true;
                        });
                      },
                      icon: const Icon(Icons.book),
                      label: const Text('Materi'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple,
                        side: const BorderSide(color: Colors.purple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Layar game
  Widget _buildGameScreen() {
    final question = questions[currentQuestionIndex];
    
    return AnimatedBuilder(
      animation: _questionAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _questionAnimation.value,
          child: Column(
            children: [
              // Progress indicator
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Question ${currentQuestionIndex + 1}/${questions.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (currentQuestionIndex + 1) / questions.length,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Question
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade50, Colors.orange.shade50],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '❌ Find the mistake:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      question.incorrectSentence,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Options
              const Text(
                'Choose the correct word:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Expanded(
                child: ListView.builder(
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    return _buildOptionButton(question, index);
                  },
                ),
              ),
              
              // Explanation
              if (showExplanation) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selectedAnswerIndex == question.correctAnswerIndex
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedAnswerIndex == question.correctAnswerIndex
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedAnswerIndex == question.correctAnswerIndex
                            ? '✅ Correct!'
                            : '💡 Explanation:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedAnswerIndex == question.correctAnswerIndex
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.explanation,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '✅ Correct: ${question.correctSentence}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // Button untuk opsi jawaban
  Widget _buildOptionButton(GrammarQuestion question, int index) {
    final isSelected = selectedAnswerIndex == index;
    final isCorrect = index == question.correctAnswerIndex;
    final showResult = showExplanation;
    
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    Color textColor = Colors.black;
    
    if (showResult) {
      if (isSelected) {
        if (isCorrect) {
          backgroundColor = Colors.green.shade100;
          borderColor = Colors.green;
          textColor = Colors.green.shade800;
        } else {
          backgroundColor = Colors.red.shade100;
          borderColor = Colors.red;
          textColor = Colors.red.shade800;
        }
      } else if (isCorrect) {
        backgroundColor = Colors.green.shade50;
        borderColor = Colors.green.shade300;
        textColor = Colors.green.shade700;
      }
    } else if (isSelected) {
      backgroundColor = Colors.blue.shade100;
      borderColor = Colors.blue;
      textColor = Colors.blue.shade800;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: showResult ? null : () => _selectAnswer(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: borderColor,
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    question.options[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                if (showResult && isCorrect)
                  const Icon(Icons.check_circle, color: Colors.green),
                if (showResult && isSelected && !isCorrect)
                  const Icon(Icons.cancel, color: Colors.red),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Tutorial Screen
  Widget _buildTutorialScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.purple.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const AppBrandIcon(
                  size: 48,
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tutorial Grammar Rush',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pelajari cara bermain dan tips untuk mendapatkan skor tinggi!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Cara Bermain
          _buildTutorialSection(
            'Cara Bermain',
            Icons.play_circle_outline,
            Colors.green,
            [
              '1. Tekan tombol "Start Game" untuk memulai',
              '2. Baca kalimat yang salah dengan teliti',
              '3. Pilih kata yang benar dari 4 pilihan',
              '4. Baca penjelasan setelah menjawab',
              '5. Lanjut ke soal berikutnya',
              '6. Selesaikan sebanyak mungkin dalam 60 detik',
            ],
          ),

          // Tips & Strategi
          _buildTutorialSection(
            'Tips & Strategi',
            Icons.lightbulb_outline,
            Colors.orange,
            [
              '• Baca kalimat dengan teliti sebelum memilih',
              '• Perhatikan subjek dan kata kerja',
              '• Ingat aturan grammar dasar',
              '• Jangan terburu-buru, akurasi lebih penting',
              '• Baca penjelasan untuk belajar',
              '• Latihan rutin untuk meningkatkan kemampuan',
            ],
          ),

          // Sistem Poin
          _buildTutorialSection(
            'Sistem Poin',
            Icons.stars,
            Colors.purple,
            [
              '✓ Jawaban benar: +15 XP',
              '✗ Jawaban salah: 0 XP',
              '🌟 90-100%: Excellent!',
              '👍 70-89%: Good Job!',
              '💪 50-69%: Keep Trying!',
              '📚 <50%: Practice More!',
            ],
          ),

          const SizedBox(height: 20),

          // Tombol Kembali
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  showTutorial = false;
                });
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Materials Screen
  Widget _buildMaterialsScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade100, Colors.pink.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.book,
                  size: 48,
                  color: Colors.purple,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Materi Grammar',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pelajari aturan grammar yang akan muncul dalam game',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Grammar Topics
          ...grammarTopics.map((topic) => _buildGrammarTopicCard(topic)),

          const SizedBox(height: 20),

          // Tombol Kembali
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  showMaterials = false;
                });
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tutorial Section Widget
  Widget _buildTutorialSection(String title, IconData icon, Color color, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              item,
              style: const TextStyle(fontSize: 14),
            ),
          )),
        ],
      ),
    );
  }

  // Grammar Topic Card Widget
  Widget _buildGrammarTopicCard(GrammarTopic topic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Icon(topic.icon, color: Colors.purple),
        title: Text(
          topic.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          topic.description,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rules
                const Text(
                  'Aturan:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                ...topic.rules.map((rule) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: Colors.blue)),
                      Expanded(
                        child: Text(
                          rule,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 16),

                // Examples
                const Text(
                  'Contoh:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                ...topic.examples.map((example) => Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: example.startsWith('✓') 
                        ? Colors.green.shade50 
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: example.startsWith('✓') 
                          ? Colors.green.shade200 
                          : Colors.red.shade200,
                    ),
                  ),
                  child: Text(
                    example,
                    style: TextStyle(
                      fontSize: 14,
                      color: example.startsWith('✓') 
                          ? Colors.green.shade800 
                          : Colors.red.shade800,
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}