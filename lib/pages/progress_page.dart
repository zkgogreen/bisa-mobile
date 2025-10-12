import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern app bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go('/'),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Progress',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF9C27B0),
                      Color(0xFF673AB7),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.trending_up,
                    size: 40,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
          ),
          
          // Progress content
          Consumer<AppState>(
            builder: (context, appState, child) {
              return SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Overall progress card
                    _buildOverallProgressCard(context, appState),
                    
                    const SizedBox(height: 24),
                    
                    // Statistics grid
                    _buildStatisticsGrid(context, appState),
                    
                    const SizedBox(height: 24),
                    
                    // Learning streak
                    _buildLearningStreakCard(context),
                    
                    const SizedBox(height: 24),
                    
                    // Achievements section
                    _buildAchievementsSection(context),
                    
                    const SizedBox(height: 24),
                    
                    // Recent activity
                    _buildRecentActivitySection(context, appState),
                    
                    const SizedBox(height: 32),
                  ]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverallProgressCard(BuildContext context, AppState appState) {
    final completedLessons = appState.lessons.where((l) => l.isCompleted).length;
    final totalLessons = appState.lessons.length;
    final progressPercentage = totalLessons > 0 ? (completedLessons / totalLessons) : 0.0;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9C27B0),
              Color(0xFF673AB7),
            ],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Overall Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$completedLessons of $totalLessons lessons completed',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(progressPercentage * 100).round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Progress bar
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progressPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid(BuildContext context, AppState appState) {
    final stats = [
      {
        'title': 'Words Learned',
        'value': '${appState.words.length}',
        'icon': Icons.translate,
        'color': const Color(0xFF4CAF50),
      },
      {
        'title': 'Quizzes Taken',
        'value': '${appState.quizQuestions.length}',
        'icon': Icons.quiz,
        'color': const Color(0xFF2196F3),
      },
      {
        'title': 'Study Days',
        'value': '15',
        'icon': Icons.calendar_today,
        'color': const Color(0xFFFF9800),
      },
      {
        'title': 'Accuracy',
        'value': '87%',
        'icon': Icons.track_changes,
        'color': const Color(0xFFF44336),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (stat['color'] as Color).withOpacity(0.1),
                  (stat['color'] as Color).withOpacity(0.05),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (stat['color'] as Color).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    stat['icon'] as IconData,
                    color: stat['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  stat['value'] as String,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: stat['color'] as Color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat['title'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLearningStreakCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: Color(0xFFFF9800),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Learning Streak',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Text(
                  '7',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF9800),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'days',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFFFF9800),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Keep it up!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Week streak visualization
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final isActive = index < 7; // Current streak
                return Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isActive 
                        ? const Color(0xFFFF9800) 
                        : Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      isActive ? Icons.check : Icons.close,
                      color: isActive 
                          ? Colors.white 
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection(BuildContext context) {
    final achievements = [
      {
        'title': 'First Steps',
        'description': 'Complete your first lesson',
        'icon': Icons.star,
        'color': const Color(0xFFFFD700),
        'isUnlocked': true,
      },
      {
        'title': 'Word Master',
        'description': 'Learn 50 new words',
        'icon': Icons.book,
        'color': const Color(0xFF4CAF50),
        'isUnlocked': true,
      },
      {
        'title': 'Quiz Champion',
        'description': 'Score 100% on 5 quizzes',
        'icon': Icons.emoji_events,
        'color': const Color(0xFF2196F3),
        'isUnlocked': false,
      },
      {
        'title': 'Streak Master',
        'description': 'Maintain a 30-day streak',
        'icon': Icons.local_fire_department,
        'color': const Color(0xFFFF9800),
        'isUnlocked': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              final isUnlocked = achievement['isUnlocked'] as bool;
              
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 16),
                child: Card(
                  elevation: isUnlocked ? 4 : 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isUnlocked 
                          ? (achievement['color'] as Color).withOpacity(0.1)
                          : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isUnlocked 
                                ? (achievement['color'] as Color).withOpacity(0.2)
                                : Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            achievement['icon'] as IconData,
                            color: isUnlocked 
                                ? achievement['color'] as Color
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          achievement['title'] as String,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isUnlocked 
                                ? null
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection(BuildContext context, AppState appState) {
    final activities = [
      {
        'title': 'Completed "Basic Greetings" lesson',
        'time': '2 hours ago',
        'icon': Icons.check_circle,
        'color': const Color(0xFF4CAF50),
      },
      {
        'title': 'Learned 5 new words',
        'time': '1 day ago',
        'icon': Icons.translate,
        'color': const Color(0xFF2196F3),
      },
      {
        'title': 'Scored 90% on vocabulary quiz',
        'time': '2 days ago',
        'icon': Icons.quiz,
        'color': const Color(0xFFFF9800),
      },
      {
        'title': 'Started "Family Members" lesson',
        'time': '3 days ago',
        'icon': Icons.play_circle,
        'color': const Color(0xFF9C27B0),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
            itemBuilder: (context, index) {
              final activity = activities[index];
              
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (activity['color'] as Color).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    activity['icon'] as IconData,
                    color: activity['color'] as Color,
                    size: 20,
                  ),
                ),
                title: Text(
                  activity['title'] as String,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  activity['time'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}