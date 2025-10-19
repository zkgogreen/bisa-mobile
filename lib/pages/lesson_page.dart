import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/course.dart';
import '../data/course_data.dart';

// Halaman untuk menampilkan lesson dengan navigasi module dan hamburger menu
class LessonPage extends StatefulWidget {
  final String courseId;
  final String moduleId;
  final String? lessonId; // Optional, jika null akan menampilkan overview module
  
  const LessonPage({
    super.key,
    required this.courseId,
    required this.moduleId,
    this.lessonId,
  });

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  Course? _course;
  Module? _module;
  CourseLesson? _currentLesson;
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Method untuk memuat data course, module, dan lesson
  void _loadData() {
    setState(() {
      _isLoading = true;
    });
    
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _course = CourseData.getCourseById(widget.courseId);
        if (_course != null) {
          _module = _course!.getModuleById(widget.moduleId);
          if (widget.lessonId != null && _module != null) {
            _currentLesson = _module!.lessons
                .where((lesson) => lesson.id == widget.lessonId)
                .firstOrNull;
          }
        }
        _isLoading = false;
      });
    });
  }

  // Method untuk navigasi ke lesson tertentu
  void _navigateToLesson(CourseLesson lesson) {
    context.go('/courses/${widget.courseId}/modules/${widget.moduleId}/lessons/${lesson.id}');
  }

  // Method untuk navigasi ke quiz
  void _navigateToQuiz() {
    context.go('/courses/${widget.courseId}/modules/${widget.moduleId}/quiz');
  }

  // Method untuk navigasi ke summary
  void _navigateToSummary() {
    context.go('/courses/${widget.courseId}/modules/${widget.moduleId}/summary');
  }

  // Method untuk mark lesson sebagai completed
  void _markLessonCompleted() {
    if (_currentLesson != null && !_currentLesson!.isCompleted) {
      setState(() {
        _currentLesson = _currentLesson!.copyWith(
          isCompleted: true,
          completedDate: DateTime.now(),
        );
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lesson berhasil diselesaikan!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Method untuk mendapatkan next lesson
  CourseLesson? _getNextLesson() {
    if (_module == null || _currentLesson == null) return null;
    
    final currentIndex = _module!.lessons.indexWhere((lesson) => lesson.id == _currentLesson!.id);
    if (currentIndex >= 0 && currentIndex < _module!.lessons.length - 1) {
      return _module!.lessons[currentIndex + 1];
    }
    return null;
  }

  // Method untuk mendapatkan previous lesson
  CourseLesson? _getPreviousLesson() {
    if (_module == null || _currentLesson == null) return null;
    
    final currentIndex = _module!.lessons.indexWhere((lesson) => lesson.id == _currentLesson!.id);
    if (currentIndex > 0) {
      return _module!.lessons[currentIndex - 1];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        key: _scaffoldKey,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_course == null || _module == null) {
      return Scaffold(
        key: _scaffoldKey,
        body: const Center(
          child: Text('Course atau Module tidak ditemukan'),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Custom title header
            _buildCustomHeader(),
            // Main content
            Expanded(
              child: _currentLesson != null 
                  ? _buildLessonContent() 
                  : _buildModuleOverview(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        _currentLesson?.title ?? _module!.title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF2196F3),
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        // Hamburger menu button
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ],
    );
  }

  // Widget untuk custom header (menggantikan AppBar)
  Widget _buildCustomHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          // Title
          Expanded(
            child: Text(
              _currentLesson?.title ?? _module!.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          // Menu button
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }



  // Widget untuk drawer dengan navigasi module
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Drawer header
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF2196F3),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _course!.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _module!.title,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    // Progress indicator
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Progress Module',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: _module!.calculateProgress(),
                          backgroundColor: Colors.white30,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(_module!.calculateProgress() * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Navigation items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Module overview
                ListTile(
                  leading: const Icon(Icons.dashboard, color: Color(0xFF2196F3)),
                  title: const Text('Module Overview'),
                  selected: _currentLesson == null,
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/courses/${widget.courseId}/modules/${widget.moduleId}');
                  },
                ),
                
                const Divider(),
                
                // Lessons
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Lessons',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
                
                ...List.generate(_module!.lessons.length, (index) {
                  final lesson = _module!.lessons[index];
                  return _buildLessonListTile(lesson, index + 1);
                }),
                
                const Divider(),
                
                // Summary
                ListTile(
                  leading: const Icon(Icons.summarize, color: Colors.orange),
                  title: const Text('Ringkasan'),
                  trailing: _module!.summary.isCompleted 
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToSummary();
                  },
                ),
                
                // Quiz
                ListTile(
                  leading: const Icon(Icons.quiz, color: Colors.purple),
                  title: const Text('Quiz'),
                  trailing: _module!.quiz.isCompleted 
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToQuiz();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk lesson list tile di drawer
  Widget _buildLessonListTile(CourseLesson lesson, int number) {
    final isSelected = _currentLesson?.id == lesson.id;
    final isLocked = !lesson.isUnlocked;
    
    return ListTile(
      leading: CircleAvatar(
        radius: 12,
        backgroundColor: isLocked 
            ? Colors.grey[400]
            : lesson.isCompleted 
                ? Colors.green 
                : isSelected 
                    ? const Color(0xFF2196F3)
                    : Colors.grey[300],
        child: Text(
          number.toString(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isLocked || (!lesson.isCompleted && !isSelected) 
                ? Colors.grey[600] 
                : Colors.white,
          ),
        ),
      ),
      title: Text(
        lesson.title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isLocked ? Colors.grey[500] : Colors.black87,
        ),
      ),
      subtitle: Text(
        '${lesson.estimatedMinutes} min',
        style: TextStyle(
          fontSize: 12,
          color: isLocked ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      trailing: lesson.isCompleted 
          ? const Icon(Icons.check_circle, color: Colors.green, size: 16)
          : isLocked 
              ? const Icon(Icons.lock, color: Colors.grey, size: 16)
              : null,
      selected: isSelected,
      onTap: isLocked 
          ? null 
          : () {
              Navigator.pop(context);
              _navigateToLesson(lesson);
            },
    );
  }

  // Widget untuk module overview
  Widget _buildModuleOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Module info card
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
                Text(
                  _module!.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _module!.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildStatChip(Icons.book_outlined, '${_module!.lessons.length} Lessons'),
                    const SizedBox(width: 12),
                    _buildStatChip(Icons.access_time, '${_module!.lessons.fold(0, (sum, lesson) => sum + lesson.estimatedMinutes)} min'),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Lessons list
          const Text(
            'Lessons',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 16),
          
          ...List.generate(_module!.lessons.length, (index) {
            final lesson = _module!.lessons[index];
            return _buildLessonCard(lesson, index + 1);
          }),
          
          const SizedBox(height: 24),
          
          // Summary dan Quiz cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuizCard(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk lesson content
  Widget _buildLessonContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lesson info
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getLessonTypeColor(_currentLesson!.type),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _currentLesson!.type.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_currentLesson!.estimatedMinutes} min',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _currentLesson!.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _currentLesson!.content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
                
                // Video player placeholder (jika ada video)
                if (_currentLesson!.videoUrl != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_outline,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Video Player',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                
                const SizedBox(height: 20),
                
                // Mark as completed button
                if (!_currentLesson!.isCompleted)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _markLessonCompleted,
                      icon: const Icon(Icons.check),
                      label: const Text('Tandai Selesai'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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

  // Widget untuk bottom navigation
  Widget _buildBottomNavigation() {
    final previousLesson = _getPreviousLesson();
    final nextLesson = _getNextLesson();
    
    return Container(
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
          if (previousLesson != null)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _navigateToLesson(previousLesson),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Sebelumnya'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            )
          else
            const Expanded(child: SizedBox()),
          
          const SizedBox(width: 16),
          
          // Next button
          if (nextLesson != null)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _navigateToLesson(nextLesson),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Selanjutnya'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            )
          else
            const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  // Helper widgets
  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(CourseLesson lesson, int number) {
    final isLocked = !lesson.isUnlocked;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isLocked 
              ? Colors.grey[400]
              : lesson.isCompleted 
                  ? Colors.green 
                  : const Color(0xFF2196F3),
          child: Text(
            number.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(
          lesson.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isLocked ? Colors.grey[600] : Colors.black87,
          ),
        ),
        subtitle: Text(
          '${lesson.type} • ${lesson.estimatedMinutes} min',
          style: TextStyle(
            color: isLocked ? Colors.grey[500] : Colors.grey[600],
          ),
        ),
        trailing: lesson.isCompleted 
            ? const Icon(Icons.check_circle, color: Colors.green)
            : isLocked 
                ? const Icon(Icons.lock, color: Colors.grey)
                : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: isLocked 
            ? null 
            : () => _navigateToLesson(lesson),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
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
          const Icon(
            Icons.summarize,
            size: 32,
            color: Colors.orange,
          ),
          const SizedBox(height: 8),
          const Text(
            'Ringkasan',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Poin-poin penting',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _navigateToSummary,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text('Buka'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizCard() {
    return Container(
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
          const Icon(
            Icons.quiz,
            size: 32,
            color: Colors.purple,
          ),
          const SizedBox(height: 8),
          const Text(
            'Quiz',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_module!.quiz.questions.length} soal',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _navigateToQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text('Mulai'),
            ),
          ),
        ],
      ),
    );
  }

  Color _getLessonTypeColor(String type) {
    switch (type) {
      case 'video':
        return Colors.red;
      case 'text':
        return Colors.blue;
      case 'interactive':
        return Colors.green;
      case 'exercise':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}