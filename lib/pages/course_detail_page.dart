import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/course.dart';
import '../data/course_data.dart';

// Halaman detail course dengan informasi lengkap dan progress
class CourseDetailPage extends StatefulWidget {
  final String courseId;
  
  const CourseDetailPage({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  Course? _course;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  // Method untuk memuat data course
  void _loadCourse() {
    setState(() {
      _isLoading = true;
    });
    
    // Simulasi loading
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _course = CourseData.getCourseById(widget.courseId);
        _isLoading = false;
      });
    });
  }

  // Method untuk enroll course
  void _enrollCourse() {
    if (_course != null) {
      setState(() {
        _course = _course!.copyWith(
          isEnrolled: true,
          enrolledDate: DateTime.now(),
        );
      });
      
      // Tampilkan snackbar konfirmasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil mendaftar course "${_course!.title}"'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Method untuk melanjutkan course
  void _continueCourse() {
    if (_course != null) {
      // Cari module pertama yang belum selesai
      Module? nextModule;
      for (var module in _course!.modules) {
        if (!module.isCompleted) {
          nextModule = module;
          break;
        }
      }
      
      if (nextModule != null) {
        // Navigasi ke lesson page dengan module pertama yang belum selesai
        context.go('/courses/${_course!.id}/modules/${nextModule.id}');
      } else {
        // Jika semua module sudah selesai, tampilkan pesan
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selamat! Anda telah menyelesaikan semua module.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // Method untuk mendapatkan warna berdasarkan level
  Color _getLevelColor(String level) {
    switch (level) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Method untuk mendapatkan icon berdasarkan kategori
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Grammar':
        return Icons.menu_book;
      case 'Speaking':
        return Icons.record_voice_over;
      case 'Business':
        return Icons.business;
      case 'Writing':
        return Icons.edit;
      default:
        return Icons.school;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_course == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Course Not Found'),
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Course tidak ditemukan'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App bar dengan image
          _buildSliverAppBar(),
          
          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Course info section
                _buildCourseInfoSection(),
                
                // Progress section (jika sudah enrolled)
                if (_course!.isEnrolled) _buildProgressSection(),
                
                // Modules section
                _buildModulesSection(),
                
                // Action button
                _buildActionButton(),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk sliver app bar dengan image yang lebih modern
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 320, // Tinggi diperbesar untuk tampilan yang lebih dramatis
      pinned: true,
      stretch: true, // Memungkinkan stretch effect saat scroll ke atas
      backgroundColor: const Color(0xFF2196F3),
      foregroundColor: Colors.white,
      elevation: 0,
      // Custom leading button dengan blur effect
      leading: Container(
        margin: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ),
      // Custom actions dengan blur effect
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    // Implementasi share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Share feature coming soon!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.bookmark_border, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bookmark feature coming soon!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Course image dengan hero animation
            Hero(
              tag: 'course-image-${_course!.id}',
              child: Image.network(
                _course!.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            
            // Gradient overlay yang lebih kompleks
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.3, 0.7, 1.0],
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            
            // Positioned elements dengan animasi
            Positioned(
              bottom: 80,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge dengan styling yang lebih baik
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getCategoryIcon(_course!.category),
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _course!.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Course title dengan shadow
                  Text(
                    _course!.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Level badge dengan posisi yang lebih baik
            Positioned(
              top: 120,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _getLevelColor(_course!.level),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _getLevelColor(_course!.level).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getLevelIcon(_course!.level),
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _course!.level,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Students count badge (alternative to rating)
             Positioned(
               top: 120,
               left: 16,
               child: Container(
                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                 decoration: BoxDecoration(
                   color: Colors.green,
                   borderRadius: BorderRadius.circular(16),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.green.withOpacity(0.3),
                       blurRadius: 8,
                       offset: const Offset(0, 2),
                     ),
                   ],
                 ),
                 child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     const Icon(
                       Icons.people,
                       size: 16,
                       color: Colors.white,
                     ),
                     const SizedBox(width: 4),
                     Text(
                       '${_course!.totalLessons} Lessons',
                       style: const TextStyle(
                         color: Colors.white,
                         fontSize: 12,
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                   ],
                 ),
               ),
             ),
          ],
        ),
      ),
    );
  }

  // Helper method untuk mendapatkan icon berdasarkan level
  IconData _getLevelIcon(String level) {
    switch (level) {
      case 'Beginner':
        return Icons.school;
      case 'Intermediate':
        return Icons.trending_up;
      case 'Advanced':
        return Icons.emoji_events;
      default:
        return Icons.help_outline;
    }
  }

  // Widget untuk course info section
  Widget _buildCourseInfoSection() {
    return Container(
      margin: const EdgeInsets.all(16),
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
          // Category
          Row(
            children: [
              Icon(
                _getCategoryIcon(_course!.category),
                size: 20,
                color: const Color(0xFF2196F3),
              ),
              const SizedBox(width: 8),
              Text(
                _course!.category,
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Title
          Text(
            _course!.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Description
          Text(
            _course!.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Course stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  Icons.play_circle_outline,
                  '${_course!.totalModules}',
                  'Modules',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  Icons.book_outlined,
                  '${_course!.totalLessons}',
                  'Lessons',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  Icons.access_time,
                  '${_course!.estimatedHours}h',
                  'Duration',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk stat card
  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: const Color(0xFF2196F3),
          ),
          const SizedBox(height: 8),
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
      ),
    );
  }

  // Widget untuk progress section
  Widget _buildProgressSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            'Progress Belajar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Overall progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Keseluruhan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${(_course!.progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2196F3),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          LinearProgressIndicator(
            value: _course!.progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
          ),
          
          const SizedBox(height: 16),
          
          // Enrolled date
          if (_course!.enrolledDate != null)
            Text(
              'Dimulai: ${_formatDate(_course!.enrolledDate!)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }

  // Widget untuk modules section
  Widget _buildModulesSection() {
    return Container(
      margin: const EdgeInsets.all(16),
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
            'Modules',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // List modules
          ...List.generate(_course!.modules.length, (index) {
            final module = _course!.modules[index];
            return _buildModuleCard(module, index);
          }),
        ],
      ),
    );
  }

  // Widget untuk module card
  Widget _buildModuleCard(Module module, int index) {
    final isLocked = !module.isUnlocked && !_course!.isEnrolled;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isLocked ? Colors.grey[100] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: module.isCompleted ? Colors.green : Colors.grey[300]!,
          width: module.isCompleted ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isLocked 
              ? Colors.grey[400]
              : module.isCompleted 
                  ? Colors.green 
                  : const Color(0xFF2196F3),
          child: Icon(
            isLocked 
                ? Icons.lock
                : module.isCompleted 
                    ? Icons.check 
                    : Icons.play_arrow,
            color: Colors.white,
          ),
        ),
        title: Text(
          module.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isLocked ? Colors.grey[600] : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              module.description,
              style: TextStyle(
                color: isLocked ? Colors.grey[500] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${module.lessons.length} lessons',
              style: TextStyle(
                fontSize: 12,
                color: isLocked ? Colors.grey[500] : Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: isLocked 
            ? null 
            : Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[600],
              ),
        onTap: isLocked 
            ? null 
            : () {
                // Navigasi ke lesson page
                context.go('/courses/${_course!.id}/modules/${module.id}');
              },
      ),
    );
  }

  // Widget untuk action button
  Widget _buildActionButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _course!.isEnrolled ? _continueCourse : _enrollCourse,
        style: ElevatedButton.styleFrom(
          backgroundColor: _course!.isEnrolled ? Colors.green : const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          _course!.isEnrolled ? 'Lanjutkan Belajar' : 'Mulai Belajar',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Helper method untuk format tanggal
  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}