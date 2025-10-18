// Model untuk data Mentor
class Mentor {
  final String id;
  final String name;
  final String profileImage;
  final String specialization;
  final List<String> languages;
  final double rating;
  final int totalStudents;
  final int experienceYears;
  final String description;
  final double pricePerHour;
  final List<String> availableDays;
  final List<String> availableTimeSlots;
  final String education;
  final List<String> certifications;
  final bool isOnline;
  final String timezone;

  const Mentor({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.specialization,
    required this.languages,
    required this.rating,
    required this.totalStudents,
    required this.experienceYears,
    required this.description,
    required this.pricePerHour,
    required this.availableDays,
    required this.availableTimeSlots,
    required this.education,
    required this.certifications,
    required this.isOnline,
    required this.timezone,
  });

  // Factory constructor untuk membuat Mentor dari JSON
  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImage: json['profileImage'] as String,
      specialization: json['specialization'] as String,
      languages: List<String>.from(json['languages'] as List),
      rating: (json['rating'] as num).toDouble(),
      totalStudents: json['totalStudents'] as int,
      experienceYears: json['experienceYears'] as int,
      description: json['description'] as String,
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      availableDays: List<String>.from(json['availableDays'] as List),
      availableTimeSlots: List<String>.from(json['availableTimeSlots'] as List),
      education: json['education'] as String,
      certifications: List<String>.from(json['certifications'] as List),
      isOnline: json['isOnline'] as bool,
      timezone: json['timezone'] as String,
    );
  }

  // Method untuk convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImage': profileImage,
      'specialization': specialization,
      'languages': languages,
      'rating': rating,
      'totalStudents': totalStudents,
      'experienceYears': experienceYears,
      'description': description,
      'pricePerHour': pricePerHour,
      'availableDays': availableDays,
      'availableTimeSlots': availableTimeSlots,
      'education': education,
      'certifications': certifications,
      'isOnline': isOnline,
      'timezone': timezone,
    };
  }
}

// Model untuk booking session dengan mentor
class MentorSession {
  final String id;
  final String mentorId;
  final String studentId;
  final DateTime scheduledDate;
  final String timeSlot;
  final int durationMinutes;
  final double totalPrice;
  final SessionStatus status;
  final String? notes;
  final DateTime createdAt;

  const MentorSession({
    required this.id,
    required this.mentorId,
    required this.studentId,
    required this.scheduledDate,
    required this.timeSlot,
    required this.durationMinutes,
    required this.totalPrice,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  factory MentorSession.fromJson(Map<String, dynamic> json) {
    return MentorSession(
      id: json['id'] as String,
      mentorId: json['mentorId'] as String,
      studentId: json['studentId'] as String,
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      timeSlot: json['timeSlot'] as String,
      durationMinutes: json['durationMinutes'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: SessionStatus.values.firstWhere(
        (e) => e.toString() == 'SessionStatus.${json['status']}',
      ),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mentorId': mentorId,
      'studentId': studentId,
      'scheduledDate': scheduledDate.toIso8601String(),
      'timeSlot': timeSlot,
      'durationMinutes': durationMinutes,
      'totalPrice': totalPrice,
      'status': status.toString().split('.').last,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// Enum untuk status session
enum SessionStatus {
  pending,
  confirmed,
  completed,
  cancelled,
  rescheduled,
}

// Extension untuk SessionStatus
extension SessionStatusExtension on SessionStatus {
  String get displayName {
    switch (this) {
      case SessionStatus.pending:
        return 'Pending';
      case SessionStatus.confirmed:
        return 'Confirmed';
      case SessionStatus.completed:
        return 'Completed';
      case SessionStatus.cancelled:
        return 'Cancelled';
      case SessionStatus.rescheduled:
        return 'Rescheduled';
    }
  }

  String get description {
    switch (this) {
      case SessionStatus.pending:
        return 'Waiting for mentor confirmation';
      case SessionStatus.confirmed:
        return 'Session confirmed and scheduled';
      case SessionStatus.completed:
        return 'Session completed successfully';
      case SessionStatus.cancelled:
        return 'Session was cancelled';
      case SessionStatus.rescheduled:
        return 'Session has been rescheduled';
    }
  }
}