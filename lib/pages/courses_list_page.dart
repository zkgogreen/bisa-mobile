import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/course.dart';
import '../data/course_data.dart';

// Halaman untuk menampilkan daftar semua courses
class CoursesListPage extends StatefulWidget {
  const CoursesListPage({super.key});

  @override
  State<CoursesListPage> createState() => _CoursesListPageState();
}

class _CoursesListPageState extends State<CoursesListPage> {
  List<Course> _courses = [];
  List<Course> _filteredCourses = [];
  String _selectedCategory = 'All';
  String _selectedLevel = 'All';
  String _searchQuery = '';

  // Daftar kategori dan level untuk filter
  final List<String> _categories = ['All', 'Grammar', 'Speaking', 'Business', 'Writing'];
  final List<String> _levels = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  // Method untuk memuat data courses
  void _loadCourses() {
    setState(() {
      _courses = CourseData.getAllCourses();
      _filteredCourses = _courses;
    });
  }

  // Method untuk filter courses berdasarkan kategori, level, dan search
  void _filterCourses() {
    setState(() {
      _filteredCourses = _courses.where((course) {
        // Filter berdasarkan kategori
        bool categoryMatch = _selectedCategory == 'All' || course.category == _selectedCategory;
        
        // Filter berdasarkan level
        bool levelMatch = _selectedLevel == 'All' || course.level == _selectedLevel;
        
        // Filter berdasarkan search query
        bool searchMatch = _searchQuery.isEmpty || 
            course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            course.description.toLowerCase().contains(_searchQuery.toLowerCase());
        
        return categoryMatch && levelMatch && searchMatch;
      }).toList();
    });
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Courses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header dengan search dan filter
          _buildHeaderSection(),
          
          // Daftar courses
          Expanded(
            child: _filteredCourses.isEmpty
                ? _buildEmptyState()
                : _buildCoursesList(),
          ),
        ],
      ),
    );
  }

  // Widget untuk header section dengan search dan filter
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF2196F3),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                _searchQuery = value;
                _filterCourses();
              },
              decoration: const InputDecoration(
                hintText: 'Cari course...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Filter chips
          Row(
            children: [
              // Category filter
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kategori',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        underline: const SizedBox(),
                        dropdownColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(
                              category,
                              style: const TextStyle(color: Colors.black87),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                          _filterCourses();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Level filter
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Level',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedLevel,
                        isExpanded: true,
                        underline: const SizedBox(),
                        dropdownColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        items: _levels.map((level) {
                          return DropdownMenuItem(
                            value: level,
                            child: Text(
                              level,
                              style: const TextStyle(color: Colors.black87),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLevel = value!;
                          });
                          _filterCourses();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan daftar courses
  Widget _buildCoursesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredCourses.length,
      itemBuilder: (context, index) {
        final course = _filteredCourses[index];
        return _buildCourseCard(course);
      },
    );
  }

  // Widget untuk card course individual
  Widget _buildCourseCard(Course course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: InkWell(
        onTap: () {
          // Navigasi ke halaman detail course
          context.go('/courses/${course.id}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course image dan level badge
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(course.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // Level badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getLevelColor(course.level),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      course.level,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                // Enrolled badge (jika sudah enrolled)
                if (course.isEnrolled)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Enrolled',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Course content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category dan title
                  Row(
                    children: [
                      Icon(
                        _getCategoryIcon(course.category),
                        size: 16,
                        color: const Color(0xFF2196F3),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.category,
                        style: const TextStyle(
                          color: Color(0xFF2196F3),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    course.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Course stats
                  Row(
                    children: [
                      _buildStatItem(Icons.play_circle_outline, '${course.totalModules} Modules'),
                      const SizedBox(width: 16),
                      _buildStatItem(Icons.book_outlined, '${course.totalLessons} Lessons'),
                      const SizedBox(width: 16),
                      _buildStatItem(Icons.access_time, '${course.estimatedHours}h'),
                    ],
                  ),
                  
                  // Progress bar (jika sudah enrolled)
                  if (course.isEnrolled) ...[
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '${(course.progress * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2196F3),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: course.progress,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk stat item (modules, lessons, hours)
  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Widget untuk empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada course ditemukan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba ubah filter atau kata kunci pencarian',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}