import '../models/mentor.dart';

// Data dummy untuk mentor-mentor yang tersedia
class MentorData {
  static List<Mentor> getAllMentors() {
    return [
      Mentor(
        id: 'mentor_001',
        name: 'Sarah Johnson',
        profileImage: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
        specialization: 'Business English',
        languages: ['English', 'Spanish'],
        rating: 4.9,
        totalStudents: 245,
        experienceYears: 8,
        description: 'Experienced English teacher specializing in business communication. I help professionals improve their English skills for career advancement.',
        pricePerHour: 25.0,
        availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
        availableTimeSlots: ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00'],
        education: 'Master\'s in Applied Linguistics, Cambridge University',
        certifications: ['TESOL Certified', 'Business English Specialist', 'IELTS Examiner'],
        isOnline: true,
        timezone: 'GMT+0',
      ),
      
      Mentor(
        id: 'mentor_002',
        name: 'Michael Chen',
        profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        specialization: 'Conversational English',
        languages: ['English', 'Mandarin'],
        rating: 4.8,
        totalStudents: 189,
        experienceYears: 6,
        description: 'Native English speaker with passion for helping students build confidence in conversation. Focus on practical, everyday English.',
        pricePerHour: 20.0,
        availableDays: ['Monday', 'Wednesday', 'Friday', 'Saturday', 'Sunday'],
        availableTimeSlots: ['08:00', '09:00', '10:00', '19:00', '20:00', '21:00'],
        education: 'Bachelor\'s in Education, University of Toronto',
        certifications: ['TEFL Certified', 'Conversation Specialist'],
        isOnline: true,
        timezone: 'GMT-5',
      ),
      
      Mentor(
        id: 'mentor_003',
        name: 'Emma Williams',
        profileImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        specialization: 'Academic English',
        languages: ['English', 'French'],
        rating: 4.9,
        totalStudents: 156,
        experienceYears: 10,
        description: 'Academic English specialist helping students prepare for IELTS, TOEFL, and university studies. Expert in academic writing and research.',
        pricePerHour: 30.0,
        availableDays: ['Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
        availableTimeSlots: ['10:00', '11:00', '13:00', '14:00', '15:00'],
        education: 'PhD in English Literature, Oxford University',
        certifications: ['IELTS Examiner', 'Academic Writing Specialist', 'TESOL Advanced'],
        isOnline: true,
        timezone: 'GMT+0',
      ),
      
      Mentor(
        id: 'mentor_004',
        name: 'David Rodriguez',
        profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        specialization: 'Grammar & Pronunciation',
        languages: ['English', 'Spanish', 'Portuguese'],
        rating: 4.7,
        totalStudents: 203,
        experienceYears: 7,
        description: 'Grammar expert and pronunciation coach. I help students master English grammar rules and improve their pronunciation for clear communication.',
        pricePerHour: 22.0,
        availableDays: ['Monday', 'Tuesday', 'Thursday', 'Friday', 'Sunday'],
        availableTimeSlots: ['09:00', '10:00', '16:00', '17:00', '18:00', '19:00'],
        education: 'Master\'s in Linguistics, Universidad de Barcelona',
        certifications: ['Grammar Specialist', 'Pronunciation Coach', 'DELE Examiner'],
        isOnline: true,
        timezone: 'GMT+1',
      ),
      
      Mentor(
        id: 'mentor_005',
        name: 'Lisa Thompson',
        profileImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
        specialization: 'Kids & Teens English',
        languages: ['English'],
        rating: 4.8,
        totalStudents: 178,
        experienceYears: 9,
        description: 'Specialized in teaching English to children and teenagers. Fun, interactive lessons that make learning English enjoyable and effective.',
        pricePerHour: 18.0,
        availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
        availableTimeSlots: ['15:00', '16:00', '17:00', '18:00'],
        education: 'Bachelor\'s in Elementary Education, UCLA',
        certifications: ['Young Learners Specialist', 'TEFL for Children', 'Child Psychology Certificate'],
        isOnline: true,
        timezone: 'GMT-8',
      ),
      
      Mentor(
        id: 'mentor_006',
        name: 'James Wilson',
        profileImage: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150&h=150&fit=crop&crop=face',
        specialization: 'IELTS Preparation',
        languages: ['English', 'German'],
        rating: 4.9,
        totalStudents: 134,
        experienceYears: 12,
        description: 'IELTS preparation specialist with 12 years of experience. Helped hundreds of students achieve their target IELTS scores for immigration and study abroad.',
        pricePerHour: 35.0,
        availableDays: ['Monday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
        availableTimeSlots: ['08:00', '09:00', '10:00', '11:00', '14:00', '15:00'],
        education: 'Master\'s in Applied Linguistics, University of Edinburgh',
        certifications: ['Official IELTS Examiner', 'IELTS Preparation Specialist', 'Cambridge Assessment Certified'],
        isOnline: true,
        timezone: 'GMT+0',
      ),
    ];
  }

  // Method untuk mendapatkan mentor berdasarkan ID
  static Mentor? getMentorById(String id) {
    try {
      return getAllMentors().firstWhere((mentor) => mentor.id == id);
    } catch (e) {
      return null;
    }
  }

  // Method untuk filter mentor berdasarkan specialization
  static List<Mentor> getMentorsBySpecialization(String specialization) {
    return getAllMentors()
        .where((mentor) => mentor.specialization.toLowerCase().contains(specialization.toLowerCase()))
        .toList();
  }

  // Method untuk filter mentor berdasarkan rating minimum
  static List<Mentor> getMentorsByMinRating(double minRating) {
    return getAllMentors()
        .where((mentor) => mentor.rating >= minRating)
        .toList();
  }

  // Method untuk filter mentor berdasarkan harga maksimum
  static List<Mentor> getMentorsByMaxPrice(double maxPrice) {
    return getAllMentors()
        .where((mentor) => mentor.pricePerHour <= maxPrice)
        .toList();
  }

  // Method untuk mendapatkan mentor yang tersedia pada hari tertentu
  static List<Mentor> getMentorsAvailableOnDay(String day) {
    return getAllMentors()
        .where((mentor) => mentor.availableDays.contains(day))
        .toList();
  }

  // Method untuk search mentor berdasarkan nama atau specialization
  static List<Mentor> searchMentors(String query) {
    final lowercaseQuery = query.toLowerCase();
    return getAllMentors()
        .where((mentor) => 
            mentor.name.toLowerCase().contains(lowercaseQuery) ||
            mentor.specialization.toLowerCase().contains(lowercaseQuery) ||
            mentor.description.toLowerCase().contains(lowercaseQuery))
        .toList();
  }
}