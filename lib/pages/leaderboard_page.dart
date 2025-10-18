import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF1A1A1A)),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top 3 podium
          _buildTopThreePodium(),
          
          const SizedBox(height: 24),
          
          // Leaderboard list
          Expanded(
            child: _buildLeaderboardList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopThreePodium() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Current user rank card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6750A4), Color(0xFF9C27B0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6750A4).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Rank',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        '#12 - You',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '1,250 XP',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Top 3 podium
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 2nd place
              _buildPodiumPlace(
                rank: 2,
                name: 'Sarah Chen',
                xp: '2,890',
                height: 80,
                color: const Color(0xFFC0C0C0),
              ),
              
              const SizedBox(width: 16),
              
              // 1st place
              _buildPodiumPlace(
                rank: 1,
                name: 'Alex Johnson',
                xp: '3,450',
                height: 100,
                color: const Color(0xFFFFD700),
              ),
              
              const SizedBox(width: 16),
              
              // 3rd place
              _buildPodiumPlace(
                rank: 3,
                name: 'Mike Wilson',
                xp: '2,650',
                height: 60,
                color: const Color(0xFFCD7F32),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumPlace({
    required int rank,
    required String name,
    required String xp,
    required double height,
    required Color color,
  }) {
    return Column(
      children: [
        // Avatar with crown for 1st place
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.only(top: rank == 1 ? 12 : 0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),
            if (rank == 1)
              const Icon(
                Icons.emoji_events,
                color: Color(0xFFFFD700),
                size: 24,
              ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Name
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        
        // XP
        Text(
          '$xp XP',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Podium base
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            border: Border.all(
              color: color,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList() {
    final users = [
      {'rank': 4, 'name': 'Emma Davis', 'xp': 2420, 'avatar': Icons.person, 'streak': 12},
      {'rank': 5, 'name': 'James Brown', 'xp': 2380, 'avatar': Icons.person, 'streak': 8},
      {'rank': 6, 'name': 'Lisa Wang', 'xp': 2250, 'avatar': Icons.person, 'streak': 15},
      {'rank': 7, 'name': 'David Miller', 'xp': 2180, 'avatar': Icons.person, 'streak': 6},
      {'rank': 8, 'name': 'Anna Garcia', 'xp': 2050, 'avatar': Icons.person, 'streak': 9},
      {'rank': 9, 'name': 'Tom Anderson', 'xp': 1980, 'avatar': Icons.person, 'streak': 4},
      {'rank': 10, 'name': 'Sophie Taylor', 'xp': 1920, 'avatar': Icons.person, 'streak': 11},
      {'rank': 11, 'name': 'Ryan Clark', 'xp': 1850, 'avatar': Icons.person, 'streak': 7},
      {'rank': 12, 'name': 'You', 'xp': 1250, 'avatar': Icons.person, 'streak': 7, 'isCurrentUser': true},
      {'rank': 13, 'name': 'Maria Lopez', 'xp': 1180, 'avatar': Icons.person, 'streak': 3},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final isCurrentUser = user['isCurrentUser'] == true;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCurrentUser 
                  ? const Color(0xFF6750A4).withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isCurrentUser
                  ? Border.all(
                      color: const Color(0xFF6750A4),
                      width: 2,
                    )
                  : null,
            ),
            child: Row(
              children: [
                // Rank
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? const Color(0xFF6750A4)
                        : _getRankColor(user['rank'] as int).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${user['rank']}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isCurrentUser
                            ? Colors.white
                            : _getRankColor(user['rank'] as int),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isCurrentUser
                          ? [const Color(0xFF6750A4), const Color(0xFF9C27B0)]
                          : [Colors.grey[400]!, Colors.grey[600]!],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    user['avatar'] as IconData,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Name and streak
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isCurrentUser
                              ? const Color(0xFF6750A4)
                              : const Color(0xFF1A1A1A),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 14,
                            color: Colors.orange[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${user['streak']} day streak',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // XP
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? const Color(0xFF6750A4)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${user['xp']} XP',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isCurrentUser
                          ? Colors.white
                          : const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank <= 3) return const Color(0xFFFFD700);
    if (rank <= 10) return const Color(0xFF6750A4);
    return Colors.grey;
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Leaderboard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('This Week'),
              leading: Radio(value: 1, groupValue: 1, onChanged: (value) {}),
            ),
            ListTile(
              title: const Text('This Month'),
              leading: Radio(value: 2, groupValue: 1, onChanged: (value) {}),
            ),
            ListTile(
              title: const Text('All Time'),
              leading: Radio(value: 3, groupValue: 1, onChanged: (value) {}),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}