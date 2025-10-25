import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

// Model untuk kartu memori
class MemoryCard {
  final String id;
  final String word;
  final String translation;
  final String emoji;
  bool isFlipped;
  bool isMatched;
  bool isVisible;

  MemoryCard({
    required this.id,
    required this.word,
    required this.translation,
    required this.emoji,
    this.isFlipped = false,
    this.isMatched = false,
    this.isVisible = true,
  });
}

class MemoryCardsPage extends StatefulWidget {
  const MemoryCardsPage({super.key});

  @override
  State<MemoryCardsPage> createState() => _MemoryCardsPageState();
}

class _MemoryCardsPageState extends State<MemoryCardsPage>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _flipAnimationController;
  late AnimationController _matchAnimationController;
  late AnimationController _scoreAnimationController;
  late Animation<double> _flipAnimation;
  late Animation<double> _matchAnimation;
  late Animation<double> _scoreAnimation;

  // Game state
  List<MemoryCard> cards = [];
  List<MemoryCard> flippedCards = [];
  int score = 0;
  int moves = 0;
  int matches = 0;
  bool gameActive = false;
  bool gameCompleted = false;
  Timer? flipBackTimer;

  // Data vocabulary untuk kartu
  List<Map<String, String>> vocabulary = [
    {"word": "Apple", "translation": "Apel", "emoji": "🍎"},
    {"word": "Cat", "translation": "Kucing", "emoji": "🐱"},
    {"word": "House", "translation": "Rumah", "emoji": "🏠"},
    {"word": "Car", "translation": "Mobil", "emoji": "🚗"},
    {"word": "Book", "translation": "Buku", "emoji": "📚"},
    {"word": "Sun", "translation": "Matahari", "emoji": "☀️"},
    {"word": "Water", "translation": "Air", "emoji": "💧"},
    {"word": "Tree", "translation": "Pohon", "emoji": "🌳"},
  ];

  @override
  void initState() {
    super.initState();
    
    // Setup animasi
    _flipAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _matchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipAnimationController, curve: Curves.easeInOut),
    );
    
    _matchAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _matchAnimationController, curve: Curves.elasticOut),
    );
    
    _scoreAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _scoreAnimationController, curve: Curves.elasticOut),
    );

    _initializeGame();
  }

  @override
  void dispose() {
    flipBackTimer?.cancel();
    _flipAnimationController.dispose();
    _matchAnimationController.dispose();
    _scoreAnimationController.dispose();
    super.dispose();
  }

  // Inisialisasi game
  void _initializeGame() {
    cards.clear();
    
    // Ambil 6 kata pertama untuk game 4x3 = 12 kartu
    final selectedVocab = vocabulary.take(6).toList();
    
    // Buat kartu untuk kata bahasa Inggris
    for (int i = 0; i < selectedVocab.length; i++) {
      cards.add(MemoryCard(
        id: 'word_$i',
        word: selectedVocab[i]['word']!,
        translation: selectedVocab[i]['translation']!,
        emoji: selectedVocab[i]['emoji']!,
      ));
    }
    
    // Buat kartu untuk terjemahan
    for (int i = 0; i < selectedVocab.length; i++) {
      cards.add(MemoryCard(
        id: 'translation_$i',
        word: selectedVocab[i]['word']!,
        translation: selectedVocab[i]['translation']!,
        emoji: selectedVocab[i]['emoji']!,
      ));
    }
    
    // Shuffle kartu
    cards.shuffle();
    
    setState(() {
      score = 0;
      moves = 0;
      matches = 0;
      gameActive = false;
      gameCompleted = false;
      flippedCards.clear();
    });
  }

  // Mulai game
  void _startGame() {
    setState(() {
      gameActive = true;
    });
  }

  // Handle tap kartu
  void _onCardTap(MemoryCard card) {
    if (!gameActive || card.isFlipped || card.isMatched || flippedCards.length >= 2) {
      return;
    }

    setState(() {
      card.isFlipped = true;
      flippedCards.add(card);
    });

    if (flippedCards.length == 2) {
      moves++;
      _checkMatch();
    }
  }

  // Cek apakah kartu cocok
  void _checkMatch() {
    final card1 = flippedCards[0];
    final card2 = flippedCards[1];
    
    // Kartu cocok jika kata yang sama tapi ID berbeda (satu word, satu translation)
    final isMatch = card1.word == card2.word && card1.id != card2.id;
    
    if (isMatch) {
      // Match berhasil
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          card1.isMatched = true;
          card2.isMatched = true;
          matches++;
          score += 20;
          flippedCards.clear();
        });
        
        // Animate match
        _matchAnimationController.forward().then((_) {
          _matchAnimationController.reverse();
        });
        
        // Animate score
        _scoreAnimationController.forward().then((_) {
          _scoreAnimationController.reverse();
        });
        
        // Cek apakah game selesai
        if (matches == vocabulary.take(6).length) {
          _completeGame();
        }
      });
    } else {
      // Match gagal, flip kembali setelah delay
      flipBackTimer = Timer(const Duration(milliseconds: 1000), () {
        setState(() {
          card1.isFlipped = false;
          card2.isFlipped = false;
          flippedCards.clear();
        });
      });
    }
  }

  // Game selesai
  void _completeGame() {
    setState(() {
      gameCompleted = true;
      gameActive = false;
    });
    
    // Bonus score berdasarkan efisiensi
    final efficiency = (matches * 2) / moves;
    int bonusScore = 0;
    
    if (efficiency >= 0.8) {
      bonusScore = 50; // Perfect atau hampir perfect
    } else if (efficiency >= 0.6) {
      bonusScore = 30; // Good
    } else if (efficiency >= 0.4) {
      bonusScore = 10; // Okay
    }
    
    setState(() {
      score += bonusScore;
    });
    
    _showCompletionDialog(bonusScore);
  }

  // Dialog selesai
  void _showCompletionDialog(int bonusScore) {
    final efficiency = ((matches * 2) / moves * 100).round();
    String grade = '';
    Color gradeColor = Colors.grey;
    
    if (efficiency >= 80) {
      grade = 'Perfect! 🌟';
      gradeColor = Colors.green;
    } else if (efficiency >= 60) {
      grade = 'Great! 👍';
      gradeColor = Colors.blue;
    } else if (efficiency >= 40) {
      grade = 'Good! 😊';
      gradeColor = Colors.orange;
    } else {
      grade = 'Keep Practicing! 💪';
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
            const Text('Memory game completed!'),
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
                    'Final Score: $score XP',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: gradeColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Moves: $moves'),
                  Text('Efficiency: $efficiency%'),
                  if (bonusScore > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Bonus: +$bonusScore XP',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
              context.go('/games');
            },
            child: const Text('Back to Games'),
          ),
        ],
      ),
    );
  }

  // Reset game
  void _resetGame() {
    flipBackTimer?.cancel();
    _initializeGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Memory Cards',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/games'),
        ),
        actions: [
          if (gameActive) ...[
            // Moves counter
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Moves: $moves',
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
        child: !gameActive && !gameCompleted
            ? _buildStartScreen()
            : _buildGameScreen(),
      ),
    );
  }

  // Layar mulai
  Widget _buildStartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink.shade100, Colors.purple.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  '🧠 Memory Cards',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Match English words with their translations!',
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
                        'How to Play:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('• Tap cards to flip them'),
                      const Text('• Match English words with translations'),
                      const Text('• Remember card positions'),
                      const Text('• Complete with fewer moves for bonus!'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Layar game
  Widget _buildGameScreen() {
    return Column(
      children: [
        // Progress info
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text(
                    'Matches',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '$matches/6',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'Moves',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '$moves',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'Score',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '$score XP',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Game grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              return _buildMemoryCard(cards[index]);
            },
          ),
        ),
      ],
    );
  }

  // Widget kartu memori dengan animasi flip
  Widget _buildMemoryCard(MemoryCard card) {
    return AnimatedBuilder(
      animation: _matchAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: card.isMatched ? _matchAnimation.value : 1.0,
          child: GestureDetector(
            onTap: () => _onCardTap(card),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return RotationTransition(
                      turns: animation,
                      child: child,
                    );
                  },
                  child: card.isFlipped || card.isMatched
                      ? _buildCardFront(card)
                      : _buildCardBack(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Bagian depan kartu (konten)
  Widget _buildCardFront(MemoryCard card) {
    final isWordCard = card.id.startsWith('word_');
    
    return Container(
      key: ValueKey('front_${card.id}'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: card.isMatched
              ? [Colors.green.shade100, Colors.green.shade200]
              : isWordCard
                  ? [Colors.blue.shade100, Colors.blue.shade200]
                  : [Colors.purple.shade100, Colors.purple.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              card.emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              isWordCard ? card.word : card.translation,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: card.isMatched
                    ? Colors.green.shade800
                    : isWordCard
                        ? Colors.blue.shade800
                        : Colors.purple.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            if (card.isMatched) ...[
              const SizedBox(height: 4),
              Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Bagian belakang kartu (tersembunyi)
  Widget _buildCardBack() {
    return Container(
      key: const ValueKey('back'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade300, Colors.grey.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.help_outline,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }
}