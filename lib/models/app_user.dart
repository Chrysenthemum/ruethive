import '../core/state/role_provider.dart';

/// Represents the currently logged-in user.
///
/// All user identity strings in the app come from this single model.
/// When Firebase Auth is integrated, replace [AppUser.dummy] with a
/// real Firestore fetch — nothing else in the UI needs to change.
class AppUser {
  final String name;
  final String studentId;
  final String email;
  final String department;
  final String batch;      // e.g. "23 Series"
  final String section;    // e.g. "A"
  final UserRole role;
  final String memberSince; // human-readable, e.g. "August 2023"

  const AppUser({
    required this.name,
    required this.studentId,
    required this.email,
    required this.department,
    required this.batch,
    required this.section,
    required this.role,
    required this.memberSince,
  });

  /// Short first name for greetings like "Welcome, Dipannita!"
  String get firstName => name.split(' ').first;

  /// Initials for avatar fallback, e.g. "DB"
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }

  /// One-line academic summary, e.g. "CSE • 23 Series • Section A"
  String get academicSummary => '$department • $batch • Section $section';

  /// Dummy user for development — replace with Firestore in production.
  static const AppUser dummy = AppUser(
    name: 'Dipannita Biswas',
    studentId: '2303030',
    email: 'dipannitaskylight@gmail.com',
    department: 'CSE',
    batch: '23 Series',
    section: 'A',
    role: UserRole.student,
    memberSince: 'August 2023',
  );

  /// Convenience copy with a different role (for role-switching in dev).
  AppUser copyWith({
    String? name,
    String? studentId,
    String? email,
    String? department,
    String? batch,
    String? section,
    UserRole? role,
    String? memberSince,
  }) =>
      AppUser(
        name: name ?? this.name,
        studentId: studentId ?? this.studentId,
        email: email ?? this.email,
        department: department ?? this.department,
        batch: batch ?? this.batch,
        section: section ?? this.section,
        role: role ?? this.role,
        memberSince: memberSince ?? this.memberSince,
      );
}
