import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/enrollment.dart';

class EnrollmentRepository {
	static const String boxName = 'enrollments';
	final Uuid _uuid = const Uuid();

	Future<Box<Enrollment>> _openBox() async {
		if (Hive.isBoxOpen(boxName)) {
			return Hive.box<Enrollment>(boxName);
		}
		return Hive.openBox<Enrollment>(boxName);
	}

	Future<List<Enrollment>> getAll() async {
		final box = await _openBox();
		return box.values.toList(growable: false);
	}

	Future<Enrollment> create({
		required String studentId,
		required String courseId,
		required DateTime enrolledOn,
		String? grade,
	}) async {
		final box = await _openBox();
		final enrollment = Enrollment(
			id: _uuid.v4(),
			studentId: studentId,
			courseId: courseId,
			enrolledOn: enrolledOn,
			grade: grade,
		);
		await box.put(enrollment.id, enrollment);
		return enrollment;
	}

	Future<void> update(Enrollment enrollment) async {
		final box = await _openBox();
		await box.put(enrollment.id, enrollment);
	}

	Future<void> delete(String id) async {
		final box = await _openBox();
		await box.delete(id);
	}

	Future<List<Enrollment>> getByStudent(String studentId) async {
		final box = await _openBox();
		return box.values.where((e) => e.studentId == studentId).toList();
	}

	Future<List<Enrollment>> getByCourse(String courseId) async {
		final box = await _openBox();
		return box.values.where((e) => e.courseId == courseId).toList();
	}
}