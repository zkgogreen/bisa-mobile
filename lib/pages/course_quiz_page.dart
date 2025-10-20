import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/course.dart';
import '../data/course_data.dart';

// Halaman untuk menampilkan quiz course dengan pertanyaan dan hasil
class CourseQuizPage extends StatefulWidget {
  final String courseId;
  final String moduleId;
  
  const CourseQuizPage({
    super.key,
    required this.courseId,
    required this.moduleId,
  });

  @override
  State<CourseQuizPage> createState() => _CourseQuizPageState();
}

class _CourseQuizPageState extends State<CourseQuizPage> with TickerProviderStateMixin {
  Course? _course;
  Module? _module;
  ModuleQuiz? _quiz;
  bool _isLoading = true;
  
  // Quiz state
  int _currentQuestionIndex = 0;
  final Map<int, String> _userAnswers = {};
  bool _isQuizStarted = false;
  bool _isQuizCompleted = false;
  int _score = 0;
  
  // Animation controllers
  late AnimationController _progressController;
  late AnimationController _questionController;
  late Animation<double> _progressAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadData();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  // Method untuk inisialisasi animasi
  void _initializeAnimations() {
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _questionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _questionController,
      curve: Curves.easeInOut,
    ));
  }

  // Method untuk memuat data
  void _loadData() {
    setState(() {
      _isLoading = true;
    });
    
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _course = CourseData.getCourseById(widget.courseId);
        if (_course != null) {
          _module = _course!.getModuleById(widget.moduleId);
          if (_module != null) {
            _quiz = _module!.quiz;
          }
        }
        _isLoading = false;
      });
    });
  }

  // Method untuk memulai quiz
  void _startQuiz() {
    setState(() {
      _isQuizStarted = true;
      _currentQuestionIndex = 0;
      _userAnswers.clear();
    });
    _questionController.forward();
    _updateProgress();
  }

  // Method untuk update progress
  void _updateProgress() {
    final progress = (_currentQuestionIndex + 1) / _quiz!.questions.length;
    _progressController.animateTo(progress);
  }

  // Method untuk memilih jawaban
  void _selectAnswer(String answer) {
    setState(() {
      _userAnswers[_currentQuestionIndex] = answer;
    });
  }

  // Method untuk next question
  void _nextQuestion() {
    if (_currentQuestionIndex < _quiz!.questions.length - 1) {
      _questionController.reverse().then((_) {
        setState(() {
          _currentQuestionIndex++;
        });
        _questionController.forward();
        _updateProgress();
      });
    } else {
      _finishQuiz();
    }
  }

  // Method untuk previous question
  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _questionController.reverse().then((_) {
        setState(() {
          _currentQuestionIndex--;
        });
        _questionController.forward();
        _updateProgress();
      });
    }
  }

  // Method untuk menyelesaikan quiz
  void _finishQuiz() {
    _calculateScore();
    setState(() {
      _isQuizCompleted = true;
    });
    
    // Mark quiz as completed
    if (_quiz != null) {
      _quiz = _quiz!.copyWith(
        isCompleted: true,
        completedDate: DateTime.now(),
        score: _score,
      );
    }
  }

  // Method untuk menghitung score
  void _calculateScore() {
    int correctAnswers = 0;
    for (int i = 0; i < _quiz!.questions.length; i++) {
      final question = _quiz!.questions[i];
      final userAnswer = _userAnswers[i];
      if (userAnswer == question.correctAnswer) {
        correctAnswers++;
      }
    }
    _score = ((correctAnswers / _quiz!.questions.length) * 100).round();
  }

  // Method untuk restart quiz
  void _restartQuiz() {
    setState(() {
      _isQuizStarted = false;
      _isQuizCompleted = false;
      _currentQuestionIndex = 0;
      _userAnswers.clear();
      _score = 0;
    });
    _progressController.reset();
    _questionController.reset();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
          backgroundColor: const Color(0xFF673AB7),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_course == null || _module == null || _quiz == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
          backgroundColor: const Color(0xFF673AB7),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Quiz tidak ditemukan'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _isQuizCompleted 
          ? _buildResultScreen()
          : _isQuizStarted 
              ? _buildQuizScreen()
              : _buildStartScreen(),
    );
  }

  // Widget untuk app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        _isQuizCompleted 
            ? 'Hasil Quiz'
            : _isQuizStarted 
                ? 'Quiz - ${_module!.title}'
                : 'Quiz - ${_module!.title}',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF673AB7),
      foregroundColor: Colors.white,
      elevation: 0,
      actions: _isQuizStarted && !_isQuizCompleted ? [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Text(
              '${_currentQuestionIndex + 1}/${_quiz!.questions.length}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ] : null,
    );
  }

  // Widget untuk start screen
  Widget _buildStartScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Quiz info card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF673AB7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.quiz,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _quiz!.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  _quiz!.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuizStat(
                      Icons.help_outline,
                      '${_quiz!.questions.length}',
                      'Pertanyaan',
                    ),
                    _buildQuizStat(
                      Icons.access_time,
                      '${_quiz!.timeLimit}',
                      'Menit',
                    ),
                    _buildQuizStat(
                      Icons.star_outline,
                      '${_quiz!.passingScore}%',
                      'Nilai Lulus',
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Instructions card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Petunjuk Quiz',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInstruction('Baca setiap pertanyaan dengan teliti'),
                _buildInstruction('Pilih jawaban yang paling tepat'),
                _buildInstruction('Anda dapat kembali ke pertanyaan sebelumnya'),
                _buildInstruction('Pastikan semua pertanyaan terjawab'),
                _buildInstruction('Klik "Selesai" untuk mengakhiri quiz'),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Start button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _startQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF673AB7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Mulai Quiz',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk quiz screen
  Widget _buildQuizScreen() {
    final question = _quiz!.questions[_currentQuestionIndex];
    
    return Column(
      children: [
        // Progress bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pertanyaan ${_currentQuestionIndex + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${_currentQuestionIndex + 1}/${_quiz!.questions.length}',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF673AB7)),
                  );
                },
              ),
            ],
          ),
        ),
        
        // Question content
        Expanded(
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Answer options
                  ...List.generate(question.options.length, (index) {
                    final option = question.options[index];
                    final isSelected = _userAnswers[_currentQuestionIndex] == option;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _selectAnswer(option),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? const Color(0xFF673AB7).withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected 
                                  ? const Color(0xFF673AB7)
                                  : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected 
                                        ? const Color(0xFF673AB7)
                                        : Colors.grey[400]!,
                                    width: 2,
                                  ),
                                  color: isSelected 
                                      ? const Color(0xFF673AB7)
                                      : Colors.transparent,
                                ),
                                child: isSelected 
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected 
                                        ? const Color(0xFF673AB7)
                                        : Colors.black87,
                                    fontWeight: isSelected 
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        
        // Navigation buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Previous button
              if (_currentQuestionIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousQuestion,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Color(0xFF673AB7)),
                    ),
                    child: const Text(
                      'Sebelumnya',
                      style: TextStyle(color: Color(0xFF673AB7)),
                    ),
                  ),
                )
              else
                const Expanded(child: SizedBox()),
              
              const SizedBox(width: 16),
              
              // Next/Finish button
              Expanded(
                child: ElevatedButton(
                  onPressed: _userAnswers.containsKey(_currentQuestionIndex)
                      ? _currentQuestionIndex < _quiz!.questions.length - 1
                          ? _nextQuestion
                          : _finishQuiz
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF673AB7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    _currentQuestionIndex < _quiz!.questions.length - 1
                        ? 'Selanjutnya'
                        : 'Selesai',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget untuk result screen
  Widget _buildResultScreen() {
    final isPassed = _score >= _quiz!.passingScore;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Result card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isPassed ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPassed ? Icons.check : Icons.close,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isPassed ? 'Selamat!' : 'Belum Berhasil',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isPassed ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isPassed 
                      ? 'Anda telah menyelesaikan quiz dengan baik'
                      : 'Jangan menyerah, coba lagi!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Skor Anda',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_score%',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: isPassed ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nilai lulus: ${_quiz!.passingScore}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Statistics card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detail Hasil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildResultStat(
                      'Total Soal',
                      '${_quiz!.questions.length}',
                      Colors.blue,
                    ),
                    _buildResultStat(
                      'Benar',
                      '${(_score * _quiz!.questions.length / 100).round()}',
                      Colors.green,
                    ),
                    _buildResultStat(
                      'Salah',
                      '${_quiz!.questions.length - (_score * _quiz!.questions.length / 100).round()}',
                      Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _restartQuiz,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFF673AB7)),
                  ),
                  child: const Text(
                    'Ulangi Quiz',
                    style: TextStyle(color: Color(0xFF673AB7)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/courses/${widget.courseId}/modules/${widget.moduleId}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF673AB7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Kembali ke Module'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widgets
  Widget _buildQuizStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 24, color: const Color(0xFF673AB7)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInstruction(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF673AB7),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}