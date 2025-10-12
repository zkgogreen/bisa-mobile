import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/course.dart';
import '../data/course_data.dart';

// Halaman untuk menampilkan ringkasan module
class ModuleSummaryPage extends StatefulWidget {
  final String courseId;
  final String moduleId;
  
  const ModuleSummaryPage({
    super.key,
    required this.courseId,
    required this.moduleId,
  });

  @override
  State<ModuleSummaryPage> createState() => _ModuleSummaryPageState();
}

class _ModuleSummaryPageState extends State<ModuleSummaryPage> with TickerProviderStateMixin {
  Course? _course;
  Module? _module;
  ModuleSummary? _summary;
  bool _isLoading = true;
  
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // Method untuk inisialisasi animasi
  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
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
            _summary = _module!.summary;
          }
        }
        _isLoading = false;
      });
      
      // Start animations
      _fadeController.forward();
      _slideController.forward();
    });
  }

  // Method untuk mark summary sebagai completed
  void _markSummaryCompleted() {
    if (_summary != null && !_summary!.isCompleted) {
      setState(() {
        _summary = _summary!.copyWith(
          isCompleted: true,
          completedDate: DateTime.now(),
        );
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ringkasan berhasil diselesaikan!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ringkasan'),
          backgroundColor: const Color(0xFFFF9800),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_course == null || _module == null || _summary == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ringkasan'),
          backgroundColor: const Color(0xFFFF9800),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Ringkasan tidak ditemukan'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildSummaryContent(),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // Widget untuk app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Ringkasan - ${_module!.title}',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFFFF9800),
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        if (_summary!.isCompleted)
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
          ),
      ],
    );
  }

  // Widget untuk summary content
  Widget _buildSummaryContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
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
                    color: Color(0xFFFF9800),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.summarize,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _summary!.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Poin-poin penting dari ${_module!.title}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.orange[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_summary!.estimatedMinutes} menit baca',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Key points section
          const Text(
            'Poin-Poin Penting',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 16),
          
          ...List.generate(_summary!.keyPoints.length, (index) {
            return _buildKeyPointCard(_summary!.keyPoints[index], index + 1);
          }),
          
          const SizedBox(height: 24),
          
          // Content section
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
                  'Ringkasan Lengkap',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _summary!.content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Next steps section
          if (_summary!.nextSteps.isNotEmpty) ...[
            const Text(
              'Langkah Selanjutnya',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 16),
            
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
                  ...List.generate(_summary!.nextSteps.length, (index) {
                    return _buildNextStepItem(_summary!.nextSteps[index], index + 1);
                  }),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
          ],
          
          // Quiz recommendation
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF673AB7).withOpacity(0.1),
                  const Color(0xFF673AB7).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF673AB7).withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.quiz,
                  size: 32,
                  color: Color(0xFF673AB7),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Siap untuk Quiz?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Uji pemahaman Anda dengan quiz module ini',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go('/courses/${widget.courseId}/modules/${widget.moduleId}/quiz');
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Mulai Quiz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF673AB7),
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
          // Back to module button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                context.go('/courses/${widget.courseId}/modules/${widget.moduleId}');
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Module'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: Color(0xFFFF9800)),
                foregroundColor: const Color(0xFFFF9800),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Mark as completed button
          if (!_summary!.isCompleted)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _markSummaryCompleted,
                icon: const Icon(Icons.check),
                label: const Text('Tandai Selesai'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            )
          else
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Selesai',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper widgets
  Widget _buildKeyPointCard(String keyPoint, int number) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFFF9800),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              keyPoint,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepItem(String step, int number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF673AB7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              step,
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
}