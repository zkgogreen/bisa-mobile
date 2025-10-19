import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/lesson.dart';
import 'dart:math' as math;

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> with TickerProviderStateMixin {
  late AnimationController _xpAnimationController;
  late AnimationController _levelUpController;
  late Animation<double> _xpAnimation;
  late Animation<double> _levelUpAnimation;
  
  // Gamification data
  int currentXP = 1250;
  int currentLevel = 5;
  int xpToNextLevel = 1500;
  int totalXP = 1250;
  List<String> achievements = ['First Steps', 'Word Master', 'Grammar Guru'];
  int streakDays = 7;

  @override
  void initState() {
    super.initState();
    _xpAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _levelUpController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _xpAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _xpAnimationController, curve: Curves.easeOutCubic),
    );
    _levelUpAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _levelUpController, curve: Curves.elasticOut),
    );
    
    // Start animations
    _xpAnimationController.forward();
  }

  @override
  void dispose() {
    _xpAnimationController.dispose();
    _levelUpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Gamified App Bar with XP and Level
          _buildGamifiedAppBar(),
          
          // Player Stats Dashboard
          SliverToBoxAdapter(
            child: _buildPlayerStats(),
          ),
          
          // Quick Mini-Games Section
          SliverToBoxAdapter(
            child: _buildMiniGamesSection(),
          ),
          
          // Achievement Section
          SliverToBoxAdapter(
            child: _buildAchievementSection(),
          ),
          
          // Gamified Lessons List
          _buildGamifiedLessonsList(),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildGamifiedAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.go('/'),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667EEA),
                Color(0xFF764BA2),
                Color(0xFFF093FB),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      // Level Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Level $currentLevel',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Streak Counter
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '$streakDays days',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Adventure Lessons',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // XP Progress Bar
                  AnimatedBuilder(
                    animation: _xpAnimation,
                    builder: (context, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'XP: ${(currentXP * _xpAnimation.value).toInt()}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Next: $xpToNextLevel XP',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: (currentXP / xpToNextLevel) * _xpAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.amber, Colors.orange],
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerStats() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total XP',
              totalXP.toString(),
              Icons.flash_on,
              const Color(0xFFFFB74D),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Achievements',
              achievements.length.toString(),
              Icons.emoji_events,
              const Color(0xFF81C784),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Streak',
              '$streakDays days',
              Icons.local_fire_department,
              const Color(0xFFFF8A65),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniGamesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎮 Quick Games',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildMiniGameCard(
                  'Word Match',
                  'Match words with pictures',
                  Icons.extension,
                  const Color(0xFF6366F1),
                  () => _showMiniGame('Word Match'),
                ),
                _buildMiniGameCard(
                  'Grammar Rush',
                  'Fix sentences quickly',
                  Icons.speed,
                  const Color(0xFFEC4899),
                  () => _showMiniGame('Grammar Rush'),
                ),
                _buildMiniGameCard(
                  'Memory Cards',
                  'Remember vocabulary',
                  Icons.psychology,
                  const Color(0xFF10B981),
                  () => _showMiniGame('Memory Cards'),
                ),
                _buildMiniGameCard(
                  'Spelling Bee',
                  'Spell words correctly',
                  Icons.spellcheck,
                  const Color(0xFFF59E0B),
                  () => _showMiniGame('Spelling Bee'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMiniGameCard(String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🏆 Recent Achievements',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              TextButton(
                onPressed: () => _showAllAchievements(),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                return _buildAchievementBadge(achievements[index]);
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(String achievement) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            achievement,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildGamifiedLessonsList() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final lesson = appState.lessons[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: _buildGamifiedLessonCard(context, lesson, index + 1),
                );
              },
              childCount: appState.lessons.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildGamifiedLessonCard(BuildContext context, Lesson lesson, int lessonNumber) {
    final isCompleted = lesson.isCompleted;
    final isLocked = lessonNumber > currentLevel;
    final difficultyColor = _getDifficultyColor(lesson.difficulty);
    final xpReward = _getXPReward(lesson.difficulty);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: isLocked ? 2 : 4,
      child: InkWell(
        onTap: isLocked ? null : () => _startLesson(lesson, xpReward),
        child: Container(
          decoration: BoxDecoration(
            gradient: isLocked 
                ? LinearGradient(
                    colors: [Colors.grey[300]!, Colors.grey[200]!],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      difficultyColor.withOpacity(0.1),
                      difficultyColor.withOpacity(0.05),
                    ],
                  ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Lesson Status Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isLocked 
                        ? Colors.grey[400]
                        : isCompleted 
                            ? const Color(0xFF4CAF50) 
                            : difficultyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isLocked 
                          ? Colors.grey[400]!
                          : isCompleted 
                              ? const Color(0xFF4CAF50) 
                              : difficultyColor.withOpacity(0.3),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: isLocked
                        ? Icon(Icons.lock, color: Colors.grey[600], size: 24)
                        : isCompleted
                            ? const Icon(Icons.check, color: Colors.white, size: 28)
                            : Text(
                                '$lessonNumber',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: difficultyColor,
                                ),
                              ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Lesson Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lesson.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isLocked ? Colors.grey[600] : const Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          if (!isLocked) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.flash_on, size: 12, color: Colors.amber),
                                  const SizedBox(width: 2),
                                  Text(
                                    '+$xpReward XP',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lesson.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isLocked ? Colors.grey[500] : Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildLessonInfo(Icons.access_time, '${lesson.duration} min', isLocked),
                          const SizedBox(width: 16),
                          _buildLessonInfo(Icons.quiz, '${lesson.content.length} topics', isLocked),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isLocked 
                                  ? Colors.grey[300]
                                  : difficultyColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              lesson.difficulty.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isLocked ? Colors.grey[600] : difficultyColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Action Button
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isLocked 
                        ? Colors.grey[300]
                        : isCompleted 
                            ? const Color(0xFF4CAF50).withOpacity(0.1)
                            : difficultyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isLocked 
                        ? Icons.lock
                        : isCompleted 
                            ? Icons.replay 
                            : Icons.play_arrow,
                    color: isLocked 
                        ? Colors.grey[600]
                        : isCompleted 
                            ? const Color(0xFF4CAF50)
                            : difficultyColor,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonInfo(IconData icon, String text, bool isLocked) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: isLocked ? Colors.grey[500] : Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isLocked ? Colors.grey[500] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return const Color(0xFF4CAF50);
      case 'intermediate':
        return const Color(0xFFFF9800);
      case 'advanced':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF2196F3);
    }
  }

  int _getXPReward(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return 50;
      case 'intermediate':
        return 100;
      case 'advanced':
        return 150;
      default:
        return 75;
    }
  }

  void _startLesson(Lesson lesson, int xpReward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.rocket_launch, color: Color(0xFF6366F1)),
            const SizedBox(width: 8),
            const Text('Start Adventure!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ready to start "${lesson.title}"?'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.flash_on, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text('Earn +$xpReward XP on completion!'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _simulateLessonCompletion(xpReward);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
            ),
            child: const Text('Start Lesson', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _simulateLessonCompletion(int xpReward) {
    // Simulate lesson completion and XP gain
    setState(() {
      currentXP += xpReward;
      totalXP += xpReward;
    });
    
    // Show XP gained animation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.flash_on, color: Colors.amber),
            const SizedBox(width: 8),
            Text('Awesome! You earned +$xpReward XP!'),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
      ),
    );
    
    // Check for level up
    if (currentXP >= xpToNextLevel) {
      _levelUp();
    }
    
    // Restart XP animation
    _xpAnimationController.reset();
    _xpAnimationController.forward();
  }

  void _levelUp() {
    setState(() {
      currentLevel++;
      currentXP = currentXP - xpToNextLevel;
      xpToNextLevel = (xpToNextLevel * 1.2).round();
    });
    
    _levelUpController.forward().then((_) {
      _levelUpController.reset();
    });
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber),
            SizedBox(width: 8),
            Text('Level Up!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _levelUpAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + (_levelUpAnimation.value * 0.3),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      '$currentLevel',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text('Congratulations! You reached Level $currentLevel!'),
            const SizedBox(height: 8),
            const Text('New lessons unlocked!'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
            ),
            child: const Text('Awesome!', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showMiniGame(String gameName) {
    // Navigasi ke mini-games yang sudah dibuat
    switch (gameName) {
      case 'Word Match':
        context.go('/games/word-match');
        break;
      case 'Grammar Rush':
        context.go('/games/grammar-rush');
        break;
      case 'Memory Cards':
        context.go('/games/memory-cards');
        break;
      case 'Spelling Bee':
        // Spelling Bee belum dibuat, tampilkan dialog coming soon
        _showComingSoonDialog(gameName);
        break;
      default:
        _showComingSoonDialog(gameName);
    }
  }

  void _showComingSoonDialog(String gameName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.games, color: Color(0xFF6366F1)),
            const SizedBox(width: 8),
            Text(gameName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.construction,
                size: 48,
                color: Color(0xFF6366F1),
              ),
            ),
            const SizedBox(height: 16),
            Text('$gameName is coming soon!'),
            const SizedBox(height: 8),
            const Text('This mini-game will help you practice in a fun way.'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showAllAchievements() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber),
            SizedBox(width: 8),
            Text('All Achievements'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.emoji_events, color: Colors.amber),
                title: Text(achievements[index]),
                subtitle: const Text('Completed'),
                trailing: const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
              );
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}