/// Defines the four distinct user roles in the Ajyal Al-Rafidain app.
enum UserRole {
  student,
  parent,
  teacher,
  superAdmin;

  String get displayName {
    switch (this) {
      case UserRole.student:
        return 'طالب';
      case UserRole.parent:
        return 'ولي أمر';
      case UserRole.teacher:
        return 'معلم';
      case UserRole.superAdmin:
        return 'مدير النظام';
    }
  }

  String get displayNameEn {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.parent:
        return 'Parent';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.superAdmin:
        return 'Super Admin';
    }
  }

  static UserRole fromString(String value) {
    switch (value) {
      case 'student':
        return UserRole.student;
      case 'parent':
        return UserRole.parent;
      case 'teacher':
        return UserRole.teacher;
      case 'superAdmin':
      case 'super_admin':
        return UserRole.superAdmin;
      default:
        throw ArgumentError('Unknown user role: $value');
    }
  }
}
