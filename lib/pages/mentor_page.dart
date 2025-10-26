import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/mentor.dart';
import '../data/mentor_data.dart';
import '../widgets/app_brand_icon.dart';
import 'syllabus_detail_page.dart';

// Halaman Mentor untuk mencari dan memilih mentor
class MentorPage extends StatefulWidget {
  const MentorPage({super.key});

  @override
  State<MentorPage> createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> {
  List<Mentor> _mentors = [];
  List<Mentor> _filteredMentors = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialization = 'All';
  double _minRating = 0.0;

  // State untuk mentor yang dipilih dan jadwal
  Mentor? _selectedMentor;
  bool _showMentorSelection = false; // Changed: now we show schedule by default
  String? _selectedPackage;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  DateTime _currentMonth = DateTime.now();
  
  // Current assigned mentor data
  Map<String, dynamic> _assignedMentor = {
    'id': '1',
    'name': 'Dr. Sarah Johnson',
    'image': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150',
    'specialization': 'Business English & IELTS Preparation',
    'rating': 4.9,
    'experience': '8 years',
    'students': 1250,
  };

  // User schedule data with single mentor
  List<Map<String, dynamic>> _userSchedule = [
    {
      'id': '1',
      'date': '25/12/2024',
      'time': '10:00',
      'status': 'upcoming',
      'topic': 'Business Presentation Skills',
      'type': 'Private Session',
      'duration': '60 min',
    },
    {
      'id': '2', 
      'date': '27/12/2024',
      'time': '14:00',
      'status': 'upcoming',
      'topic': 'IELTS Speaking Practice',
      'type': 'Private Session',
      'duration': '60 min',
    },
    {
      'id': '3',
      'date': '20/12/2024',
      'time': '09:00',
      'status': 'completed',
      'topic': 'Email Writing & Business Communication',
      'type': 'Private Session',
      'duration': '60 min',
    },
    {
      'id': '4',
      'date': '18/12/2024',
      'time': '15:00',
      'status': 'completed',
      'topic': 'Grammar Fundamentals',
      'type': 'Private Session',
      'duration': '60 min',
    },
  ];

  // Syllabus data from assigned mentor
  List<Map<String, dynamic>> _syllabus = [
    {
      'week': 1,
      'topic': 'Grammar Fundamentals',
      'description': 'Basic grammar rules, tenses, and sentence structure',
      'status': 'completed',
    },
    {
      'week': 2,
      'topic': 'Email Writing & Business Communication',
      'description': 'Professional email writing, formal language, business vocabulary',
      'status': 'completed',
    },
    {
      'week': 3,
      'topic': 'Business Presentation Skills',
      'description': 'Presentation structure, public speaking, visual aids',
      'status': 'current',
    },
    {
      'week': 4,
      'topic': 'IELTS Speaking Practice',
      'description': 'IELTS speaking format, practice questions, fluency improvement',
      'status': 'upcoming',
    },
    {
      'week': 5,
      'topic': 'Advanced Business Vocabulary',
      'description': 'Industry-specific terms, idioms, professional expressions',
      'status': 'upcoming',
    },
    {
      'week': 6,
      'topic': 'Negotiation & Meeting Skills',
      'description': 'Business negotiations, meeting participation, discussion skills',
      'status': 'upcoming',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadMentors();
    _searchController.addListener(_filterMentors);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load data mentor
  void _loadMentors() {
    setState(() {
      _mentors = MentorData.getAllMentors();
      _filteredMentors = _mentors;
    });
  }

  // Filter mentor berdasarkan kriteria (tanpa harga)
  void _filterMentors() {
    setState(() {
      _filteredMentors = _mentors.where((mentor) {
        // Filter berdasarkan search query
        final matchesSearch =
            _searchController.text.isEmpty ||
            mentor.name.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            mentor.specialization.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );

        // Filter berdasarkan specialization
        final matchesSpecialization =
            _selectedSpecialization == 'All' ||
            mentor.specialization.contains(_selectedSpecialization);

        // Filter berdasarkan rating
        final matchesRating = mentor.rating >= _minRating;

        return matchesSearch && matchesSpecialization && matchesRating;
      }).toList();
    });
  }

  // Pilih mentor dan tampilkan jadwal
  void _selectMentor(Mentor mentor) {
    setState(() {
      _selectedMentor = mentor;
    });
  }

  // Fungsi untuk menampilkan halaman pilih mentor
  void _showMentorSelectionView() {
    setState(() {
      _showMentorSelection = true;
    });
  }

  // Fungsi untuk kembali ke halaman jadwal user
  void _backToScheduleView() {
    setState(() {
      _showMentorSelection = false;
      _selectedMentor = null;
      _selectedPackage = null;
      _selectedDate = null;
      _selectedTimeSlot = null;
    });
  }

  // Helper function untuk nama bulan
  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _showMentorSelection 
              ? (_selectedMentor != null ? 'Schedule with ${_selectedMentor?.name}' : 'Find Your Mentor')
              : 'My Learning Journey',
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: _showMentorSelection 
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
                onPressed: _backToScheduleView,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
                onPressed: () => context.go('/dashboard'),
              ),
        actions: !_showMentorSelection 
            ? [
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Color(0xFF6750A4)),
                  onPressed: _showMentorSelectionView,
                  tooltip: 'Book New Session',
                ),
              ]
            : null,
      ),
      body: _showMentorSelection 
          ? (_selectedMentor != null ? _buildMentorScheduleView() : _buildMentorListView())
          : _buildSingleMentorScheduleView(),
    );
  }

  // View daftar mentor
  Widget _buildMentorListView() {
    return Column(
      children: [
        // Search and filter section
        _buildSearchSection(),

        // Stats section
        _buildStatsSection(),

        // Mentor list
        Expanded(child: _buildMentorList()),
      ],
    );
  }

  // View jadwal single mentor
  Widget _buildSingleMentorScheduleView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mentor info card
          _buildAssignedMentorCard(),
          
          const SizedBox(height: 24),
          
          // Upcoming sessions
          _buildUpcomingSessions(),
          
          const SizedBox(height: 24),
          
          // History sessions
          _buildHistorySessions(),
          
          const SizedBox(height: 24),
          
          // Schedule calendar
          _buildMyScheduleCalendar(),
          
          const SizedBox(height: 24),
          
          // Syllabus
          _buildSyllabus(),
        ],
      ),
    );
  }

  // View jadwal mentor
  Widget _buildMentorScheduleView() {
    if (_selectedMentor == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mentor info card
          _buildSelectedMentorCard(),

          const SizedBox(height: 24),

          // Package selection
          _buildPackageSelection(),

          const SizedBox(height: 24),

          // Calendar/Schedule
          _buildScheduleCalendar(),

          const SizedBox(height: 24),

          // Available time slots
          _buildTimeSlots(),
        ],
      ),
    );
  }

  // Schedule stats widget
  Widget _buildScheduleStats() {
    final upcomingCount = _userSchedule.where((s) => s['status'] == 'upcoming').length;
    final completedCount = _userSchedule.where((s) => s['status'] == 'completed').length;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6750A4), Color(0xFF7C3AED)],
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📅 My Learning Schedule',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$upcomingCount upcoming • $completedCount completed',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.calendar_today, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  // Schedule list widget
  Widget _buildScheduleList() {
    if (_userSchedule.isEmpty) {
      return _buildEmptyScheduleState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Sessions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        ..._userSchedule.where((s) => s['status'] == 'upcoming').map((schedule) => _buildScheduleCard(schedule)).toList(),
        
        const SizedBox(height: 24),
        
        const Text(
          'Past Sessions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        ..._userSchedule.where((s) => s['status'] == 'completed').map((schedule) => _buildScheduleCard(schedule)).toList(),
      ],
    );
  }

  // Schedule card widget
  Widget _buildScheduleCard(Map<String, dynamic> schedule) {
    final isUpcoming = schedule['status'] == 'upcoming';
    final dateString = schedule['date'] as String;
    
    // Helper function to format date with relative time for longer-term bookings
    String _formatScheduleDate(String dateStr) {
      final parts = dateStr.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final date = DateTime(year, month, day);
      final now = DateTime.now();
      final difference = date.difference(now).inDays;
      
      final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                         'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      
      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Tomorrow';
      } else if (difference <= 7) {
        return 'In $difference days';
      } else if (difference <= 14) {
        return 'In ${(difference / 7).ceil()} week${difference > 7 ? 's' : ''}';
      } else {
        return '${monthNames[month - 1]} $day, $year';
      }
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUpcoming ? const Color(0xFF6750A4) : Colors.grey[300]!,
          width: isUpcoming ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Mentor image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                image: NetworkImage(schedule['mentorImage']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Schedule info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule['mentor'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${schedule['package']} Session',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      _formatScheduleDate(dateString),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      schedule['time'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Price and status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                schedule['price'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6750A4),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isUpcoming 
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isUpcoming ? 'Upcoming' : 'Completed',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isUpcoming ? const Color(0xFF10B981) : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Empty schedule state
  Widget _buildEmptyScheduleState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No sessions scheduled',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book your first session with a mentor',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // Card mentor yang dipilih
  Widget _buildSelectedMentorCard() {
    return Container(
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
      child: Row(
        children: [
          // Profile image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: DecorationImage(
                image: NetworkImage(_selectedMentor!.profileImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Mentor info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedMentor!.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _selectedMentor!.specialization,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber[600], size: 18),
                    const SizedBox(width: 4),
                    Text(
                      _selectedMentor!.rating.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_selectedMentor!.experienceYears} years exp.',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Online status
          if (_selectedMentor!.isOnline)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Online',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Pilihan paket
  Widget _buildPackageSelection() {
    final packages = [
      {'name': 'Private', 'price': '\$25', 'description': '1-on-1 session'},
      {'name': 'Semi Private', 'price': '\$18', 'description': '2-3 students'},
      {'name': 'General', 'price': '\$12', 'description': '4-6 students'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Package',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        ...packages.map((package) => _buildPackageCard(package)).toList(),
      ],
    );
  }

  // Card paket
  Widget _buildPackageCard(Map<String, String> package) {
    final isSelected = _selectedPackage == package['name'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPackage = package['name'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6750A4).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF6750A4) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package['name']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    package['description']!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  package['price']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6750A4),
                  ),
                ),
                const Text(
                  'per hour',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Kalender jadwal
  Widget _buildScheduleCalendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        
        // Date range selector
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You can book sessions from 2 weeks to 1 month in advance',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
              // Calendar header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(
                          _currentMonth.year,
                          _currentMonth.month - 1,
                        );
                      });
                    },
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text(
                    '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(
                          _currentMonth.year,
                          _currentMonth.month + 1,
                        );
                      });
                    },
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),

              // Days of week
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                    .map(
                      (day) => Text(
                        day,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 8),

              // Calendar grid with extended booking range (2 weeks to 1 month)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                ),
                itemCount: 42, // 6 weeks to show full month view
                itemBuilder: (context, index) {
                  // Calculate the first day of the month and adjust for Sunday start
                  final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
                  // weekday: 1=Monday, 7=Sunday. We want Sunday=0, so we use % 7
                  final firstSundayOffset = firstDayOfMonth.weekday % 7;
                  final displayDate = firstDayOfMonth.subtract(Duration(days: firstSundayOffset)).add(Duration(days: index));
                  
                  final isCurrentMonth = displayDate.month == _currentMonth.month;
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  final twoWeeksFromNow = today.add(const Duration(days: 14));
                  final oneMonthFromNow = today.add(const Duration(days: 30));
                  final displayDateOnly = DateTime(displayDate.year, displayDate.month, displayDate.day);
                  
                  // Available if: within 2 weeks to 1 month range from today
                  final isAvailable = displayDateOnly.isAtSameMomentAs(twoWeeksFromNow) ||
                      (displayDateOnly.isAfter(twoWeeksFromNow) && 
                       displayDateOnly.isBefore(oneMonthFromNow.add(const Duration(days: 1))));
                  
                  final isSelected = _selectedDate != null &&
                      _selectedDate!.day == displayDate.day &&
                      _selectedDate!.month == displayDate.month &&
                      _selectedDate!.year == displayDate.year;

                  return GestureDetector(
                    onTap: isAvailable
                        ? () {
                            setState(() {
                              _selectedDate = displayDate;
                            });
                          }
                        : null,
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF6750A4)
                            : isAvailable
                            ? const Color(0xFFF3F0FF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isAvailable && !isSelected
                            ? Border.all(color: const Color(0xFF6750A4), width: 1)
                            : isCurrentMonth && !isAvailable
                            ? Border.all(color: Colors.grey[300]!, width: 0.5)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          displayDate.day.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? Colors.white
                                : isAvailable
                                ? const Color(0xFF6750A4)
                                : isCurrentMonth
                                ? Colors.grey[600]
                                : Colors.grey[300],
                            fontWeight: isSelected || isAvailable
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Slot waktu tersedia
  Widget _buildTimeSlots() {
    final timeSlots = [
      '09:00',
      '10:00',
      '11:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Time Slots',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: timeSlots.map((time) {
            final isBooked =
                time == '11:00' || time == '15:00'; // Mock booked slots
            final isSelected = _selectedTimeSlot == time;
            return GestureDetector(
              onTap: isBooked
                  ? null
                  : () {
                      setState(() {
                        _selectedTimeSlot = time;
                      });
                    },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isBooked
                      ? Colors.grey[100]
                      : isSelected
                      ? const Color(0xFF6750A4)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isBooked
                        ? Colors.grey[300]!
                        : const Color(0xFF6750A4),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isBooked
                        ? Colors.grey[500]
                        : isSelected
                        ? Colors.white
                        : const Color(0xFF6750A4),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // Book session button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Validate selections
              if (_selectedPackage == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a package first'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              if (_selectedDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a date first'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              // Validate date is within booking range (2 weeks to 1 month)
              final now = DateTime.now();
              final twoWeeksFromNow = now.add(const Duration(days: 14));
              final oneMonthFromNow = now.add(const Duration(days: 30));
              
              if (_selectedDate!.isBefore(twoWeeksFromNow) || _selectedDate!.isAfter(oneMonthFromNow)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a date between 2 weeks to 1 month from today'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              if (_selectedTimeSlot == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a time slot first'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              // Add new session to user schedule
              final newSession = {
                'mentorName': _selectedMentor!.name,
                'mentorImage': _selectedMentor!.profileImage,
                'package': _selectedPackage!,
                'date': '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                'time': _selectedTimeSlot!,
                'status': 'Upcoming',
                'price': _selectedPackage == 'Private' ? 'Rp 150,000' :
                        _selectedPackage == 'Semi-Private' ? 'Rp 100,000' :
                        _selectedPackage == 'General' ? 'Rp 75,000' : 'Rp 200,000',
              };

              // Handle successful booking
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Session booked successfully!\n'
                    'Package: $_selectedPackage\n'
                    'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}\n'
                    'Time: $_selectedTimeSlot',
                  ),
                  backgroundColor: const Color(0xFF10B981),
                  duration: const Duration(seconds: 2),
                ),
              );

              // Reset selections and redirect to schedule
              setState(() {
                _userSchedule.insert(0, newSession); // Add to beginning of list
                _selectedPackage = null;
                _selectedDate = null;
                _selectedTimeSlot = null;
                _selectedMentor = null;
                _showMentorSelection = false; // Return to schedule view
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6750A4),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Book Session',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // Search section
  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Search bar
          Container(
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
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search mentors by name or specialization...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick filters
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildQuickFilter('All', _selectedSpecialization == 'All'),
                _buildQuickFilter(
                  'Business',
                  _selectedSpecialization == 'Business',
                ),
                _buildQuickFilter(
                  'Conversational',
                  _selectedSpecialization == 'Conversational',
                ),
                _buildQuickFilter(
                  'Academic',
                  _selectedSpecialization == 'Academic',
                ),
                _buildQuickFilter('IELTS', _selectedSpecialization == 'IELTS'),
                _buildQuickFilter('Kids', _selectedSpecialization == 'Kids'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Quick filter chip
  Widget _buildQuickFilter(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedSpecialization = selected ? label : 'All';
            _filterMentors();
          });
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF6750A4).withOpacity(0.1),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF6750A4) : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected ? const Color(0xFF6750A4) : Colors.grey[300]!,
        ),
      ),
    );
  }

  // Stats section
  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6750A4), Color(0xFF7C3AED)],
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '👨‍🏫 Expert Mentors',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_filteredMentors.length} mentors available',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const AppBrandIcon(size: 24, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Mentor list
  Widget _buildMentorList() {
    if (_filteredMentors.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filteredMentors.length,
        itemBuilder: (context, index) {
          final mentor = _filteredMentors[index];
          return _buildMentorCard(mentor);
        },
      ),
    );
  }

  // Mentor card (tanpa harga)
  Widget _buildMentorCard(Mentor mentor) {
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
        onTap: () => _selectMentor(mentor),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Profile image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: NetworkImage(mentor.profileImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Mentor info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                mentor.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                            if (mentor.isOnline)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF10B981,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Online',
                                  style: TextStyle(
                                    color: Color(0xFF10B981),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Text(
                          mentor.specialization,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber[600],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              mentor.rating.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.people,
                              color: Colors.grey[500],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${mentor.totalStudents} students',
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

                  // Select button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6750A4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Select',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                mentor.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Languages and experience
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      children: mentor.languages.take(2).map((language) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            language,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Text(
                    '${mentor.experienceYears} years exp.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No mentors found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // Filter dialog (tanpa filter harga)
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    'Filter Mentors',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedSpecialization = 'All';
                        _minRating = 0.0;
                        _filterMentors();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ),

            // Filter content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating filter
                    const Text(
                      'Minimum Rating',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _minRating,
                      min: 0.0,
                      max: 5.0,
                      divisions: 10,
                      label: _minRating.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          _minRating = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Apply button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _filterMentors();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6750A4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan info mentor yang ditugaskan
  Widget _buildAssignedMentorCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6750A4), Color(0xFF7C3AED)],
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
          // Mentor image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(37),
              child: Image.network(
                _assignedMentor['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 40),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Mentor info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _assignedMentor['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _assignedMentor['specialization'],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${_assignedMentor['rating']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${_assignedMentor['experience']} experience',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan upcoming sessions
  Widget _buildUpcomingSessions() {
    final upcomingSessions = _userSchedule.where((s) => s['status'] == 'upcoming').toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.schedule, color: Color(0xFF6750A4), size: 24),
            const SizedBox(width: 8),
            const Text(
              'Upcoming Sessions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6750A4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${upcomingSessions.length} sessions',
                style: const TextStyle(
                  color: Color(0xFF6750A4),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (upcomingSessions.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: const Center(
              child: Text(
                'No upcoming sessions scheduled',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          ...upcomingSessions.map((session) => _buildSessionCard(session, true)),
      ],
    );
  }

  // Widget untuk menampilkan history sessions
  Widget _buildHistorySessions() {
    final completedSessions = _userSchedule.where((s) => s['status'] == 'completed').toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.history, color: Color(0xFF6750A4), size: 24),
            const SizedBox(width: 8),
            const Text(
              'Session History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${completedSessions.length} completed',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (completedSessions.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: const Center(
              child: Text(
                'No completed sessions yet',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          ...completedSessions.map((session) => _buildSessionCard(session, false)),
      ],
    );
  }

  // Widget untuk session card
  Widget _buildSessionCard(Map<String, dynamic> session, bool isUpcoming) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUpcoming ? const Color(0xFF6750A4).withOpacity(0.2) : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Date and time
          Container(
            width: 80,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUpcoming 
                  ? const Color(0xFF6750A4).withOpacity(0.1)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  session['date'].split('/')[0], // Day
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isUpcoming ? const Color(0xFF6750A4) : Colors.grey[600],
                  ),
                ),
                Text(
                  session['time'],
                  style: TextStyle(
                    fontSize: 12,
                    color: isUpcoming ? const Color(0xFF6750A4) : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Session details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session['topic'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  session['type'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  session['duration'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          // Status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isUpcoming 
                  ? const Color(0xFF6750A4).withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isUpcoming ? 'Upcoming' : 'Completed',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isUpcoming ? const Color(0xFF6750A4) : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk calendar schedule
  Widget _buildMyScheduleCalendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_month, color: Color(0xFF6750A4), size: 24),
            const SizedBox(width: 8),
            const Text(
              'My Schedule',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
              // Calendar header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
                      });
                    },
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text(
                    '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
                      });
                    },
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Days of week
              Row(
                children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                    .map((day) => Expanded(
                          child: Center(
                            child: Text(
                              day,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),
              // Calendar grid
              SizedBox(
                height: 240,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: 42,
                  itemBuilder: (context, index) {
                    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
                    final firstSundayOffset = firstDayOfMonth.weekday % 7;
                    final displayDate = firstDayOfMonth.add(Duration(days: index - firstSundayOffset));
                    
                    // Check if this date has a session
                    final hasSession = _userSchedule.any((session) {
                      final sessionDate = session['date'].split('/');
                      final sessionDateTime = DateTime(
                        int.parse(sessionDate[2]),
                        int.parse(sessionDate[1]),
                        int.parse(sessionDate[0]),
                      );
                      return sessionDateTime.day == displayDate.day &&
                             sessionDateTime.month == displayDate.month &&
                             sessionDateTime.year == displayDate.year;
                    });
                    
                    final isCurrentMonth = displayDate.month == _currentMonth.month;
                    final isToday = displayDate.day == DateTime.now().day &&
                                   displayDate.month == DateTime.now().month &&
                                   displayDate.year == DateTime.now().year;
                    
                    return Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: hasSession
                            ? const Color(0xFF6750A4).withOpacity(0.2)
                            : isToday
                                ? const Color(0xFF6750A4)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: hasSession
                            ? Border.all(color: const Color(0xFF6750A4), width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '${displayDate.day}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: hasSession ? FontWeight.bold : FontWeight.normal,
                            color: isToday
                                ? Colors.white
                                : hasSession
                                    ? const Color(0xFF6750A4)
                                    : isCurrentMonth
                                        ? Colors.black
                                        : Colors.grey[400],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget untuk syllabus
  Widget _buildSyllabus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.school, color: Color(0xFF6750A4), size: 24),
            const SizedBox(width: 8),
            const Text(
              'Learning Syllabus',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._syllabus.map((item) => _buildSyllabusItem(item)),
      ],
    );
  }

  // Widget untuk syllabus item
  Widget _buildSyllabusItem(Map<String, dynamic> item) {
    Color statusColor;
    IconData statusIcon;
    
    switch (item['status']) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'current':
        statusColor = const Color(0xFF6750A4);
        statusIcon = Icons.play_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.radio_button_unchecked;
    }
    
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail syllabus untuk pre-study
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SyllabusDetailPage(syllabusItem: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: item['status'] == 'current' 
                ? const Color(0xFF6750A4).withOpacity(0.3)
                : Colors.grey[200]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Week number
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  'W${item['week']}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['topic'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Status icon
            Icon(
              statusIcon,
              color: statusColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
