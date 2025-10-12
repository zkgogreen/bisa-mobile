import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Model untuk item Word Match
class WordMatchItem {
  final String word;
  final String imageIcon; // Menggunakan emoji sebagai gambar
  final String id;
  bool isMatched;

  WordMatchItem({
    required this.word,
    required this.imageIcon,
    required this.id,
    this.isMatched = false,
  });
}

class WordMatchPage extends StatefulWidget {
  const WordMatchPage({super.key});

  @override
  State<WordMatchPage> createState() => _WordMatchPageState();
}

class _WordMatchPageState extends State<WordMatchPage>
    with TickerProviderStateMixin {
  // Animation controllers untuk efek visual
  late AnimationController _scoreAnimationController;
  late AnimationController _matchAnimationController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _matchAnimation;

  // Game state
  int score = 0;
  int totalMatches = 0;
  bool gameCompleted = false;
  String? draggedWordId;

  // Data game - kata-kata dengan emoji sebagai gambar
  List<WordMatchItem> words = [
    WordMatchItem(word: "Apple", imageIcon: "🍎", id: "1"),
    WordMatchItem(word: "Cat", imageIcon: "🐱", id: "2"),
    WordMatchItem(word: "House", imageIcon: "🏠", id: "3"),
    WordMatchItem(word: "Car", imageIcon: "🚗", id: "4"),
    WordMatchItem(word: "Book", imageIcon: "📚", id: "5"),
    WordMatchItem(word: "Sun", imageIcon: "☀️", id: "6"),
  ];

  List<WordMatchItem> images = [];

  @override
  void initState() {
    super.initState();
    
    // Setup animasi
    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _matchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _scoreAnimationController, curve: Curves.elasticOut),
    );
    _matchAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _matchAnimationController, curve: Curves.bounceOut),
    );

    // Shuffle gambar untuk posisi acak
    images = List.from(words);
    images.shuffle();
    words.shuffle();
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    _matchAnimationController.dispose();
    super.dispose();
  }

  // Fungsi untuk menangani match yang berhasil
  void _handleSuccessfulMatch(String wordId) {
    setState(() {
      // Update status matched
      words.firstWhere((w) => w.id == wordId).isMatched = true;
      images.firstWhere((i) => i.id == wordId).isMatched = true;
      
      score += 10;
      totalMatches++;
      
      // Cek apakah game selesai
      if (totalMatches == words.length) {
        gameCompleted = true;
      }
    });

    // Trigger animasi
    _scoreAnimationController.forward().then((_) {
      _scoreAnimationController.reverse();
    });
    _matchAnimationController.forward().then((_) {
      _matchAnimationController.reverse();
    });

    // Hapus referensi drag
    draggedWordId = null;

    // Tampilkan feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Great! +10 XP'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );

    // Jika game selesai, tampilkan dialog
    if (gameCompleted) {
      _showCompletionDialog();
    }
  }

  // Dialog ketika game selesai
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Congratulations!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You completed Word Match!'),
            const SizedBox(height: 16),
            Text(
              'Final Score: $score XP',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
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

  // Reset game untuk main lagi
  void _resetGame() {
    setState(() {
      score = 0;
      totalMatches = 0;
      gameCompleted = false;
      draggedWordId = null;
      
      // Reset status matched
      for (var word in words) {
        word.isMatched = false;
      }
      for (var image in images) {
        image.isMatched = false;
      }
      
      // Shuffle ulang
      words.shuffle();
      images.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Word Match',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/lessons'),
        ),
        actions: [
          // Score display dengan animasi
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: AnimatedBuilder(
                animation: _scoreAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scoreAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header dengan instruksi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade100, Colors.purple.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    '🎯 Drag words to matching images',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Progress: $totalMatches/${words.length}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  LinearProgressIndicator(
                    value: totalMatches / words.length,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Game area
            Expanded(
              child: Row(
                children: [
                  // Kolom kata-kata (kiri)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Words',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: words.length,
                            itemBuilder: (context, index) {
                              final word = words[index];
                              return _buildDraggableWord(word);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 24),
                  
                  // Kolom gambar (kanan)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Images',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              final image = images[index];
                              return _buildDropTarget(image);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk kata yang bisa di-drag
  Widget _buildDraggableWord(WordMatchItem word) {
    if (word.isMatched) {
      // Jika sudah matched, tampilkan versi yang disabled
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Opacity(
          opacity: 0.3,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 12),
                Text(
                  word.word,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Draggable<String>(
        data: word.id,
        onDragStarted: () {
          setState(() {
            draggedWordId = word.id;
          });
        },
        onDragEnd: (details) {
          setState(() {
            draggedWordId = null;
          });
        },
        feedback: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue),
            ),
            child: Text(
              word.word,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              word.word,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            word.word,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk target drop (gambar)
  Widget _buildDropTarget(WordMatchItem image) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: AnimatedBuilder(
        animation: _matchAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: image.isMatched ? _matchAnimation.value : 1.0,
            child: DragTarget<String>(
              onAccept: (wordId) {
                if (wordId == image.id) {
                  _handleSuccessfulMatch(wordId);
                } else {
                  // Match salah
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Try again! 🤔'),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              onWillAccept: (wordId) => !image.isMatched,
              builder: (context, candidateData, rejectedData) {
                final isHovering = candidateData.isNotEmpty;
                final isCorrectHover = candidateData.contains(image.id);
                
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: image.isMatched
                        ? Colors.green.shade100
                        : isHovering
                            ? (isCorrectHover ? Colors.green.shade50 : Colors.red.shade50)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: image.isMatched
                          ? Colors.green
                          : isHovering
                              ? (isCorrectHover ? Colors.green : Colors.red)
                              : Colors.grey.shade300,
                      width: 2,
                    ),
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
                        image.imageIcon,
                        style: const TextStyle(fontSize: 40),
                      ),
                      if (image.isMatched) ...[
                        const SizedBox(height: 8),
                        Text(
                          image.word,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}