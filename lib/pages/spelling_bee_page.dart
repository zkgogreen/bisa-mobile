import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

// Model untuk kata yang akan dieja
class SpellingWord {
  final String word;
  final String definition;
  final String category;
  final int difficulty; // 1-3 (Easy, Medium, Hard)
  final String pronunciation;

  SpellingWord({
    required this.word,
    required this.definition,
    required this.category,
    required this.difficulty,
    required this.pronunciation,
  });
}

// Halaman utama game Spelling Bee
class SpellingBeePage extends StatefulWidget {
  const SpellingBeePage({super.key});

  @override
  State<SpellingBeePage> createState() => _SpellingBeePageState();
}

class _SpellingBeePageState extends State<SpellingBeePage>
    with TickerProviderStateMixin {
  // Animation controllers untuk efek visual
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _shakeController;
  
  // Animation objects
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;

  // Game state variables
  bool _isGameStarted = false;
  bool _isGameCompleted = false;
  int _currentWordIndex = 0;
  int _score = 0;
  int _lives = 3;
  int _streak = 0;
  int _maxStreak = 0;
  String _userInput = '';
  bool _showHint = false;
  bool _isAnswerRevealed = false;
  
  // Timer variables
  Timer? _gameTimer;
  int _timeRemaining = 30; // 30 detik per kata
  bool _isTimerActive = false;
  
  // Controllers
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  // Data kata-kata untuk game Spelling Bee
  final List<SpellingWord> _words = [
    // Easy words (difficulty 1)
    SpellingWord(
      word: 'BEAUTIFUL',
      definition: 'Indah, cantik',
      category: 'Adjective',
      difficulty: 1,
      pronunciation: '/ˈbjuːtɪfʊl/',
    ),
    SpellingWord(
      word: 'ELEPHANT',
      definition: 'Gajah',
      category: 'Animal',
      difficulty: 1,
      pronunciation: '/ˈelɪfənt/',
    ),
    SpellingWord(
      word: 'COMPUTER',
      definition: 'Komputer',
      category: 'Technology',
      difficulty: 1,
      pronunciation: '/kəmˈpjuːtər/',
    ),
    SpellingWord(
      word: 'RAINBOW',
      definition: 'Pelangi',
      category: 'Nature',
      difficulty: 1,
      pronunciation: '/ˈreɪnboʊ/',
    ),
    SpellingWord(
      word: 'LIBRARY',
      definition: 'Perpustakaan',
      category: 'Place',
      difficulty: 1,
      pronunciation: '/ˈlaɪbreri/',
    ),
    
    // Medium words (difficulty 2)
    SpellingWord(
      word: 'NECESSARY',
      definition: 'Perlu, diperlukan',
      category: 'Adjective',
      difficulty: 2,
      pronunciation: '/ˈnesəseri/',
    ),
    SpellingWord(
      word: 'RESTAURANT',
      definition: 'Restoran',
      category: 'Place',
      difficulty: 2,
      pronunciation: '/ˈrestərɑːnt/',
    ),
    SpellingWord(
      word: 'ENVIRONMENT',
      definition: 'Lingkungan',
      category: 'Nature',
      difficulty: 2,
      pronunciation: '/ɪnˈvaɪrənmənt/',
    ),
    SpellingWord(
      word: 'PSYCHOLOGY',
      definition: 'Psikologi',
      category: 'Science',
      difficulty: 2,
      pronunciation: '/saɪˈkɑːlədʒi/',
    ),
    SpellingWord(
      word: 'TEMPERATURE',
      definition: 'Suhu',
      category: 'Science',
      difficulty: 2,
      pronunciation: '/ˈtemprətʃər/',
    ),
    
    // Hard words (difficulty 3)
    SpellingWord(
      word: 'PHARMACEUTICAL',
      definition: 'Farmasi, obat-obatan',
      category: 'Science',
      difficulty: 3,
      pronunciation: '/ˌfɑːrməˈsuːtɪkəl/',
    ),
    SpellingWord(
      word: 'ENTREPRENEUR',
      definition: 'Pengusaha',
      category: 'Business',
      difficulty: 3,
      pronunciation: '/ˌɑːntrəprəˈnɜːr/',
    ),
    SpellingWord(
      word: 'CONSCIENTIOUS',
      definition: 'Teliti, berhati-hati',
      category: 'Adjective',
      difficulty: 3,
      pronunciation: '/ˌkɑːnʃiˈenʃəs/',
    ),
    SpellingWord(
      word: 'PRONUNCIATION',
      definition: 'Pengucapan',
      category: 'Language',
      difficulty: 3,
      pronunciation: '/prəˌnʌnsiˈeɪʃən/',
    ),
    SpellingWord(
      word: 'ACCOMMODATION',
      definition: 'Akomodasi, penginapan',
      category: 'Travel',
      difficulty: 3,
      pronunciation: '/əˌkɑːməˈdeɪʃən/',
    ),
  ];

  List<SpellingWord> _gameWords = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _shuffleWords();
  }

  // Inisialisasi animasi
  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    
    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticInOut),
    );
  }

  // Mengacak urutan kata
  void _shuffleWords() {
    _gameWords = List.from(_words);
    _gameWords.shuffle(Random());
  }

  // Memulai timer untuk kata saat ini
  void _startTimer() {
    _stopTimer(); // Stop timer sebelumnya jika ada
    
    setState(() {
      _timeRemaining = 30; // Reset timer ke 30 detik
      _isTimerActive = true;
    });
    
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining--;
      });
      
      if (_timeRemaining <= 0) {
        _stopTimer();
        _handleTimeUp();
      }
    });
  }

  // Menghentikan timer
  void _stopTimer() {
    _gameTimer?.cancel();
    _gameTimer = null;
    setState(() {
      _isTimerActive = false;
    });
  }

  // Menangani waktu habis
  void _handleTimeUp() {
    setState(() {
      _lives--;
      _streak = 0;
    });
    
    _shakeController.reset();
    _shakeController.forward();
    
    if (_lives <= 0) {
      _endGame();
    } else {
      _showTimeUpDialog();
    }
  }

  // Menampilkan dialog waktu habis
  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.timer_off, color: Colors.orange, size: 30),
            SizedBox(width: 10),
            Text('Waktu Habis!', style: TextStyle(color: Colors.orange)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ejaan yang benar: "${_gameWords[_currentWordIndex].word}"',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Nyawa tersisa: $_lives',
              style: const TextStyle(fontSize: 14, color: Colors.orange),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
              _nextWord(); // Lanjut ke kata berikutnya
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Lanjut'),
          ),
        ],
      ),
    );
  }

  // Memulai game
  void _startGame() {
    setState(() {
      _isGameStarted = true;
      _isGameCompleted = false;
      _currentWordIndex = 0;
      _score = 0;
      _lives = 3;
      _streak = 0;
      _maxStreak = 0;
      _userInput = '';
      _showHint = false;
      _isAnswerRevealed = false;
    });
    _shuffleWords();
    _fadeController.forward();
    _scaleController.forward();
    
    // Mulai timer untuk kata pertama
    _startTimer();
    
    // Auto focus pada input field
    Future.delayed(const Duration(milliseconds: 500), () {
      _inputFocusNode.requestFocus();
    });
  }

  // Mengecek jawaban user
  void _checkAnswer() {
    if (_userInput.trim().isEmpty) return;
    
    _stopTimer(); // Stop timer saat jawaban diperiksa
    
    final currentWord = _gameWords[_currentWordIndex];
    final isCorrect = _userInput.trim().toUpperCase() == currentWord.word;
    
    if (isCorrect) {
      _handleCorrectAnswer();
    } else {
      _handleWrongAnswer();
    }
  }

  // Menangani jawaban benar
  void _handleCorrectAnswer() {
    // Bonus skor berdasarkan sisa waktu
    final timeBonus = _timeRemaining * 2;
    final baseScore = 10 * _gameWords[_currentWordIndex].difficulty;
    
    setState(() {
      _score += baseScore + timeBonus;
      _streak++;
      if (_streak > _maxStreak) _maxStreak = _streak;
    });
    
    _scaleController.reset();
    _scaleController.forward();
    
    _showSuccessDialog();
  }

  // Menangani jawaban salah
  void _handleWrongAnswer() {
    setState(() {
      _lives--;
      _streak = 0;
    });
    
    _shakeController.reset();
    _shakeController.forward();
    
    if (_lives <= 0) {
      _endGame();
    } else {
      _showWrongAnswerDialog();
    }
  }

  // Menampilkan dialog jawaban benar
  void _showSuccessDialog() {
    final timeBonus = _timeRemaining * 2;
    final baseScore = 10 * _gameWords[_currentWordIndex].difficulty;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 10),
            Text('Benar!', style: TextStyle(color: Colors.green)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ejaan kata "${_gameWords[_currentWordIndex].word}" benar!',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Skor Dasar: +$baseScore',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            if (timeBonus > 0)
              Text(
                'Bonus Waktu: +$timeBonus',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            Text(
              'Total: +${baseScore + timeBonus}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
              _nextWord(); // Lanjut ke kata berikutnya
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Lanjut'),
          ),
        ],
      ),
    );
  }

  // Menampilkan dialog jawaban salah
  void _showWrongAnswerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.close, color: Colors.red, size: 30),
            SizedBox(width: 10),
            Text('Salah!', style: TextStyle(color: Colors.red)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ejaan yang benar: "${_gameWords[_currentWordIndex].word}"',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Nyawa tersisa: $_lives',
              style: const TextStyle(fontSize: 14, color: Colors.red),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
              _nextWord(); // Lanjut ke kata berikutnya
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Lanjut'),
          ),
        ],
      ),
    );
  }

  // Pindah ke kata berikutnya
  void _nextWord() {
    if (_currentWordIndex < _gameWords.length - 1) {
      setState(() {
        _currentWordIndex++;
        _userInput = '';
        _showHint = false;
        _isAnswerRevealed = false;
        _inputController.clear();
      });
      
      _fadeController.reset();
      _fadeController.forward();
      
      // Mulai timer untuk kata berikutnya
      _startTimer();
      
      // Auto focus pada input field
      Future.delayed(const Duration(milliseconds: 300), () {
        _inputFocusNode.requestFocus();
      });
    } else {
      _endGame();
    }
  }

  // Mengakhiri game
  void _endGame() {
    setState(() {
      _isGameCompleted = true;
    });
    
    _showGameCompletedDialog();
  }

  // Menampilkan dialog game selesai
  void _showGameCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber, size: 30),
            SizedBox(width: 10),
            Text('Game Selesai!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Skor Akhir: $_score',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Streak Terbaik: $_maxStreak'),
            Text('Kata Diselesaikan: ${_currentWordIndex + 1}/${_gameWords.length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Kembali ke halaman games
            },
            child: const Text('Kembali'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Main Lagi'),
          ),
        ],
      ),
    );
  }

  // Reset game
  void _resetGame() {
    setState(() {
      _isGameStarted = false;
      _isGameCompleted = false;
      _currentWordIndex = 0;
      _score = 0;
      _lives = 3;
      _streak = 0;
      _maxStreak = 0;
      _userInput = '';
      _showHint = false;
      _isAnswerRevealed = false;
      _inputController.clear();
    });
    
    _fadeController.reset();
    _scaleController.reset();
    _shakeController.reset();
  }

  // Menampilkan hint
  void _showHintDialog() {
    final currentWord = _gameWords[_currentWordIndex];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.lightbulb, color: Colors.amber),
            SizedBox(width: 10),
            Text('Hint'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kategori: ${currentWord.category}'),
            const SizedBox(height: 8),
            Text('Tingkat: ${_getDifficultyText(currentWord.difficulty)}'),
            const SizedBox(height: 8),
            Text('Jumlah huruf: ${currentWord.word.length}'),
            const SizedBox(height: 8),
            Text('Huruf pertama: ${currentWord.word[0]}'),
            const SizedBox(height: 8),
            Text('Huruf terakhir: ${currentWord.word[currentWord.word.length - 1]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // Mendapatkan teks tingkat kesulitan
  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Mudah';
      case 2:
        return 'Sedang';
      case 3:
        return 'Sulit';
      default:
        return 'Unknown';
    }
  }

  // Mendapatkan warna berdasarkan tingkat kesulitan
  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Mendapatkan warna timer berdasarkan sisa waktu
  Color _getTimerColor() {
    if (_timeRemaining > 20) return Colors.green;
    if (_timeRemaining > 10) return Colors.orange;
    return Colors.red;
  }

  @override
  void dispose() {
    _stopTimer(); // Stop timer saat dispose
    _fadeController.dispose();
    _scaleController.dispose();
    _shakeController.dispose();
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Spelling Bee',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF59E0B),
        foregroundColor: Colors.white,
        elevation: 0,
        // Menampilkan statistik game di AppBar saat game dimulai
        actions: _isGameStarted && !_isGameCompleted
            ? [
                // Timer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: _getTimerColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getTimerColor(), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer, size: 16, color: _getTimerColor()),
                      const SizedBox(width: 4),
                      Text(
                        '$_timeRemaining',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getTimerColor(),
                        ),
                      ),
                    ],
                  ),
                ),
                // Score
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$_score',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // Lives
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.favorite, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$_lives',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 600 ? 32 : 16,
            vertical: 16,
          ),
          child: !_isGameStarted ? _buildStartScreen() : _buildGameScreen(),
        ),
      ),
    );
  }

  // Membangun layar awal
  Widget _buildStartScreen() {
    return Column(
      children: [
        const SizedBox(height: 40),
        // Icon dan judul
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.spellcheck,
            size: 80,
            color: Color(0xFFF59E0B),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Spelling Bee',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Eja kata-kata dengan benar dan tingkatkan kemampuan spelling Anda!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 40),
        
        // Informasi game
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Cara Bermain:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 16),
              _buildGameRule(
                Icons.headphones,
                'Dengarkan definisi kata',
                'Kata akan dibacakan beserta artinya',
              ),
              _buildGameRule(
                Icons.keyboard,
                'Ketik ejaan yang benar',
                'Masukkan ejaan kata dengan huruf kapital',
              ),
              _buildGameRule(
                Icons.lightbulb,
                'Gunakan hint jika perlu',
                'Dapatkan petunjuk kategori dan huruf pertama',
              ),
              _buildGameRule(
                Icons.favorite,
                'Hati-hati dengan nyawa',
                'Anda memiliki 3 nyawa untuk menyelesaikan game',
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        
        // Tombol mulai
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _startGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Mulai Bermain',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // Membangun aturan game
  Widget _buildGameRule(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFF59E0B),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Membangun layar game
  Widget _buildGameScreen() {
    final currentWord = _gameWords[_currentWordIndex];
    
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Progress indicator
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kata ${_currentWordIndex + 1} dari ${_gameWords.length}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          'Streak: $_streak',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF59E0B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (_currentWordIndex + 1) / _gameWords.length,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Word card
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            _shakeAnimation.value * 10 * 
                            ((_shakeAnimation.value * 4).floor() % 2 == 0 ? 1 : -1),
                            0,
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Difficulty badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getDifficultyColor(currentWord.difficulty)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _getDifficultyText(currentWord.difficulty),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _getDifficultyColor(currentWord.difficulty),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Definition
                                Text(
                                  currentWord.definition,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                
                                // Pronunciation
                                Text(
                                  currentWord.pronunciation,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF6B7280),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                
                                // Category
                                Text(
                                  'Kategori: ${currentWord.category}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              
              // Input field
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Ketik ejaan kata:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _inputController,
                      focusNode: _inputFocusNode,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'Masukkan ejaan...',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFF59E0B),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _userInput = value;
                        });
                      },
                      onSubmitted: (_) => _checkAnswer(),
                    ),
                    const SizedBox(height: 16),
                    
                    // Action buttons
                    Row(
                      children: [
                        // Hint button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _showHintDialog,
                            icon: const Icon(Icons.lightbulb),
                            label: const Text('Hint'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFF59E0B),
                              side: const BorderSide(color: Color(0xFFF59E0B)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Submit button
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: _userInput.trim().isNotEmpty ? _checkAnswer : null,
                            icon: const Icon(Icons.check),
                            label: const Text('Cek Jawaban'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF59E0B),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}