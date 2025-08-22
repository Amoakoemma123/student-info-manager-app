import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'models/student.dart';
import 'models/course.dart';
import 'models/enrollment.dart';
import 'repos/student_repository.dart';
import 'repos/course_repository.dart';
import 'repos/enrollment_repository.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
	return StudentRepository();
});

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
	return CourseRepository();
});

final enrollmentRepositoryProvider = Provider<EnrollmentRepository>((ref) {
	return EnrollmentRepository();
});

final studentsBoxProvider = FutureProvider<Box<Student>>((ref) async {
	return Hive.openBox<Student>(StudentRepository.boxName);
});

final coursesBoxProvider = FutureProvider<Box<Course>>((ref) async {
	return Hive.openBox<Course>(CourseRepository.boxName);
});

final enrollmentsBoxProvider = FutureProvider<Box<Enrollment>>((ref) async {
	return Hive.openBox<Enrollment>(EnrollmentRepository.boxName);
});