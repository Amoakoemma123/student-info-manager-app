import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/course.dart';

class CourseRepository {
	static const String boxName = 'courses';
	final Uuid _uuid = const Uuid();

	Future<Box<Course>> _openBox() async {
		if (Hive.isBoxOpen(boxName)) {
			return Hive.box<Course>(boxName);
		}
		return Hive.openBox<Course>(boxName);
	}

	Future<List<Course>> getAll() async {
		final box = await _openBox();
		return box.values.toList(growable: false);
	}

	Future<Course> create({
		required String code,
		required String title,
		required int creditHours,
	}) async {
		final box = await _openBox();
		final course = Course(
			id: _uuid.v4(),
			code: code,
			title: title,
			creditHours: creditHours,
		);
		await box.put(course.id, course);
		return course;
	}

	Future<void> update(Course course) async {
		final box = await _openBox();
		await box.put(course.id, course);
	}

	Future<void> delete(String id) async {
		final box = await _openBox();
		await box.delete(id);
	}

	Future<Course?> getById(String id) async {
		final box = await _openBox();
		return box.get(id);
	}
}