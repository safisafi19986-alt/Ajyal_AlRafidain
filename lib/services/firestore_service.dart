import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

/// Service layer for all 14 Firestore collections.
///
/// Collections:
/// 1. users           - Base user accounts
/// 2. students         - Student profiles with unique codes
/// 3. parents          - Parent profiles with linked students
/// 4. teachers         - Teacher profiles
/// 5. curriculum       - Curriculum/course definitions
/// 6. lessons          - Individual lessons within curricula
/// 7. quizzes          - Quizzes linked to lessons
/// 8. student_progress - Student lesson progress tracking
/// 9. quiz_results     - Student quiz results
/// 10. games           - Educational mini-games
/// 11. student_games   - Student game play history
/// 12. ai_reports      - AI-generated performance reports
/// 13. subscriptions   - User subscription plans
/// 14. notifications   - User notifications
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ── Collection References ──

  CollectionReference<Map<String, dynamic>> get usersCollection =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get studentsCollection =>
      _firestore.collection('students');

  CollectionReference<Map<String, dynamic>> get parentsCollection =>
      _firestore.collection('parents');

  CollectionReference<Map<String, dynamic>> get teachersCollection =>
      _firestore.collection('teachers');

  CollectionReference<Map<String, dynamic>> get curriculumCollection =>
      _firestore.collection('curriculum');

  CollectionReference<Map<String, dynamic>> get lessonsCollection =>
      _firestore.collection('lessons');

  CollectionReference<Map<String, dynamic>> get quizzesCollection =>
      _firestore.collection('quizzes');

  CollectionReference<Map<String, dynamic>> get studentProgressCollection =>
      _firestore.collection('student_progress');

  CollectionReference<Map<String, dynamic>> get quizResultsCollection =>
      _firestore.collection('quiz_results');

  CollectionReference<Map<String, dynamic>> get gamesCollection =>
      _firestore.collection('games');

  CollectionReference<Map<String, dynamic>> get studentGamesCollection =>
      _firestore.collection('student_games');

  CollectionReference<Map<String, dynamic>> get aiReportsCollection =>
      _firestore.collection('ai_reports');

  CollectionReference<Map<String, dynamic>> get subscriptionsCollection =>
      _firestore.collection('subscriptions');

  CollectionReference<Map<String, dynamic>> get notificationsCollection =>
      _firestore.collection('notifications');

  // ── Users ──

  Future<AppUser?> getUser(String uid) async {
    final doc = await usersCollection.doc(uid).get();
    if (doc.exists) return AppUser.fromFirestore(doc);
    return null;
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    data['updatedAt'] = Timestamp.now();
    await usersCollection.doc(uid).update(data);
  }

  // ── Students ──

  Future<List<Student>> getStudentsByGrade(int grade) async {
    final query =
        await studentsCollection.where('grade', isEqualTo: grade).get();
    return query.docs.map((doc) => Student.fromFirestore(doc)).toList();
  }

  Future<Student?> getStudentByCode(String code) async {
    final query = await studentsCollection
        .where('uniqueCode', isEqualTo: code)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return Student.fromFirestore(query.docs.first);
  }

  // ── Curriculum ──

  Future<List<Curriculum>> getCurriculumByGrade(int grade) async {
    final query = await curriculumCollection
        .where('grade', isEqualTo: grade)
        .where('isActive', isEqualTo: true)
        .get();
    return query.docs.map((doc) => Curriculum.fromFirestore(doc)).toList();
  }

  // ── Lessons ──

  Future<List<Lesson>> getLessonsByCurriculum(String curriculumId) async {
    final query = await lessonsCollection
        .where('curriculumId', isEqualTo: curriculumId)
        .where('isActive', isEqualTo: true)
        .orderBy('orderIndex')
        .get();
    return query.docs.map((doc) => Lesson.fromFirestore(doc)).toList();
  }

  // ── Quizzes ──

  Future<Quiz?> getQuizByLesson(String lessonId) async {
    final query = await quizzesCollection
        .where('lessonId', isEqualTo: lessonId)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return Quiz.fromFirestore(query.docs.first);
  }

  // ── Student Progress ──

  Future<StudentProgress?> getStudentProgress({
    required String studentId,
    required String lessonId,
  }) async {
    final query = await studentProgressCollection
        .where('studentId', isEqualTo: studentId)
        .where('lessonId', isEqualTo: lessonId)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return StudentProgress.fromFirestore(query.docs.first);
  }

  Future<void> updateStudentProgress(StudentProgress progress) async {
    await studentProgressCollection
        .doc(progress.id)
        .set(progress.toFirestore());
  }

  // ── Quiz Results ──

  Future<void> saveQuizResult(QuizResult result) async {
    await quizResultsCollection.doc(result.id).set(result.toFirestore());
  }

  Future<List<QuizResult>> getStudentQuizResults(String studentId) async {
    final query = await quizResultsCollection
        .where('studentId', isEqualTo: studentId)
        .orderBy('completedAt', descending: true)
        .get();
    return query.docs.map((doc) => QuizResult.fromFirestore(doc)).toList();
  }

  // ── Games ──

  Future<List<Game>> getActiveGames() async {
    final query =
        await gamesCollection.where('isActive', isEqualTo: true).get();
    return query.docs.map((doc) => Game.fromFirestore(doc)).toList();
  }

  // ── Student Games ──

  Future<void> updateStudentGame(StudentGame studentGame) async {
    await studentGamesCollection
        .doc(studentGame.id)
        .set(studentGame.toFirestore());
  }

  // ── AI Reports ──

  Future<List<AiReport>> getStudentReports(String studentId) async {
    final query = await aiReportsCollection
        .where('studentId', isEqualTo: studentId)
        .orderBy('generatedAt', descending: true)
        .get();
    return query.docs.map((doc) => AiReport.fromFirestore(doc)).toList();
  }

  // ── Subscriptions ──

  Future<Subscription?> getActiveSubscription(String userId) async {
    final query = await subscriptionsCollection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return Subscription.fromFirestore(query.docs.first);
  }

  // ── Notifications ──

  Stream<List<NotificationModel>> getUserNotifications(String userId) {
    return notificationsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList());
  }

  Future<void> markNotificationRead(String notificationId) async {
    await notificationsCollection.doc(notificationId).update({
      'isRead': true,
    });
  }

  /// Initialize Firestore indexes and security rules reference.
  /// Note: Actual Firestore rules should be deployed via firebase CLI.
  /// This documents the expected collection structure.
  static Map<String, String> get collectionDescriptions => {
        'users': 'Base user accounts with role, phone, and profile info',
        'students':
            'Student profiles with unique codes for parent linking (grades 4-6)',
        'parents': 'Parent profiles with list of linked student IDs',
        'teachers': 'Teacher profiles with assigned grades and subjects',
        'curriculum': 'Course/curriculum definitions per grade and subject',
        'lessons':
            'Individual lessons with HLS video URLs, ordered within curriculum',
        'quizzes':
            'AI-driven quizzes linked to lessons with multiple-choice questions',
        'student_progress':
            'Per-student lesson progress tracking (watch time, completion)',
        'quiz_results': 'Student quiz attempt results and scores',
        'games': 'Educational mini-game definitions',
        'student_games': 'Student game play history and high scores',
        'ai_reports': 'AI-generated performance analytics and recommendations',
        'subscriptions': 'User subscription plans and payment records (IQD)',
        'notifications': 'User notifications (in-app)',
      };
}
