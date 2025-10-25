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
  bool _isFilterVisible = false; // State untuk mengontrol visibility filter

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
        return const Color(0xFF4CAF50); // Green
      case 'Intermediate':
        return const Color(0xFFFF9800); // Orange
      case 'Advanced':
        return const Color(0xFFF44336); // Red
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

  // Method untuk membuat badge dengan styling yang konsisten
  Widget _buildBadge(String text, Color color, {bool isLeft = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Courses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orangeAccent,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 44,
      ),
      body: Column(
        children: [
          // Header dengan search dan filter
          _buildHeaderSection(),
          
          // Spacing antara header dan content
          const SizedBox(height: 16),
          
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

  // Widget untuk header section dengan search dan filter yang diperbaiki
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Search bar yang diperbaiki dengan design yang lebih compact
          TextField(
            onChanged: (value) {
              _searchQuery = value;
              _filterCourses();
            },
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Cari course yang kamu inginkan...',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 20),
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 4),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isFilterVisible = !_isFilterVisible;
                    });
                  },
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: _isFilterVisible 
                            ? const Color(0xFF6C63FF)
                            : Colors.grey[600],
                        size: 20,
                      ),
                      // Badge untuk menunjukkan filter aktif
                      if (_selectedCategory != 'All' || _selectedLevel != 'All')
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF6C63FF),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          
          // Filter section dengan animasi dan design yang diperbaiki
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isFilterVisible ? null : 0,
            child: _isFilterVisible ? Column(
              children: [
                const SizedBox(height: 20),
                
                // Filter section dengan chips yang diperbaiki
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category filter chips dengan ChoiceChip
                    Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          color: const Color(0xFF6C63FF),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Kategori:',
                          style: TextStyle(
                            color: Color(0xFF6C63FF),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((category) {
                          final isSelected = _selectedCategory == category;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey[800],
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                                _filterCourses();
                              },
                              backgroundColor: Colors.grey[200],
                              selectedColor: const Color(0xFF6C63FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Level filter chips dengan ChoiceChip
                    Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: const Color(0xFF6C63FF),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Level:',
                          style: TextStyle(
                            color: Color(0xFF6C63FF),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _levels.map((level) {
                          final isSelected = _selectedLevel == level;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(
                                level,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey[800],
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedLevel = level;
                                });
                                _filterCourses();
                              },
                              backgroundColor: Colors.grey[200],
                              selectedColor: const Color(0xFF6C63FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    
                    // Clear filters button (jika ada filter aktif)
                    if (_selectedCategory != 'All' || _selectedLevel != 'All') ...[
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = 'All';
                              _selectedLevel = 'All';
                            });
                            _filterCourses();
                          },
                          icon: const Icon(
                            Icons.clear_all,
                            color: Color(0xFF6C63FF),
                            size: 16,
                          ),
                          label: const Text(
                            'Reset Filter',
                            style: TextStyle(
                              color: Color(0xFF6C63FF),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF).withOpacity(0.1),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ) : null,
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan daftar courses dengan spacing yang diperbaiki
  Widget _buildCoursesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredCourses.length,
      itemBuilder: (context, index) {
        final course = _filteredCourses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16), // Spacing yang diperbaiki
          child: _buildCourseCard(course),
        );
      },
    );
  }

  // Widget untuk card course individual dengan semua perbaikan
  Widget _buildCourseCard(Course course) {
    return Container(
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
            // Course image dan badges yang diperbaiki posisinya
            Stack(
              children: [
                Container(
                  height: 140,
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
                
                // Enrolled badge di kiri atas
                if (course.isEnrolled)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _buildBadge('Enrolled', const Color(0xFF4CAF50), isLeft: true),
                  ),
                
                // Level badge di kanan atas
                Positioned(
                  top: 12,
                  right: 12,
                  child: _buildBadge(course.level, _getLevelColor(course.level)),
                ),
              ],
            ),
            
            // Course content dengan spacing yang diperbaiki
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
                        color: const Color(0xFF6C63FF),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        course.category,
                        style: const TextStyle(
                          color: Color(0xFF6C63FF),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    course.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Rating dan jumlah peserta (fitur baru)
                   Row(
                     children: [
                       const Icon(Icons.star, color: Colors.amber, size: 16),
                       const SizedBox(width: 4),
                       Text(
                         '4.8 (1.2k)',
                         style: TextStyle(
                           fontSize: 12,
                           color: Colors.grey[600],
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                       const Spacer(),
                       Icon(Icons.people, color: Colors.grey[500], size: 14),
                       const SizedBox(width: 4),
                       Text(
                         '${course.totalLessons} lessons',
                         style: TextStyle(
                           fontSize: 12,
                           color: Colors.grey[600],
                         ),
                       ),
                     ],
                   ),
                  
                  const SizedBox(height: 12),
                  
                  // Progress bar yang diperbaiki (lebih tebal)
                  if (course.isEnrolled) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${(course.progress * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6C63FF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: course.progress,
                        minHeight: 8, // Progress bar yang lebih tebal
                        backgroundColor: Colors.grey[300],
                        color: const Color(0xFF6C63FF),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 12),
                  
                  // Course stats dengan spacing yang diperbaiki
                   Row(
                     children: [
                       Icon(Icons.play_circle_outline, size: 14, color: Colors.grey[500]),
                       const SizedBox(width: 4),
                       Text(
                         '${course.totalModules} modules',
                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                       ),
                       const SizedBox(width: 16),
                       Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                       const SizedBox(width: 4),
                       Text(
                         '${course.estimatedHours}h',
                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                       ),
                     ],
                   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk empty state yang diperbaiki
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isNotEmpty ? Icons.search_off : Icons.school_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty 
                  ? "Course tidak ditemukan"
                  : "Belum ada course tersedia",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? "Coba ubah filter atau kata pencarianmu"
                  : "Course akan segera ditambahkan",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isNotEmpty || _selectedCategory != 'All' || _selectedLevel != 'All') ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _selectedCategory = 'All';
                    _selectedLevel = 'All';
                  });
                  _filterCourses();
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reset Pencarian'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}