import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/student.dart';

class StudentRepository {
	static const String boxName = 'students';
	final Uuid _uuid = const Uuid();

	Future<Box<Student>> _openBox() async {
		if (Hive.isBoxOpen(boxName)) {
			return Hive.box<Student>(boxName);
		}
		return Hive.openBox<Student>(boxName);
	}

	Future<List<Student>> getAll() async {
		final box = await _openBox();
		return box.values.toList(growable: false);
	}

	Future<Student> create({
		required String firstName,
		required String lastName,
		required DateTime dateOfBirth,
		required String email,
		required String phone,
	}) async {
		final box = await _openBox();
		final student = Student(
			id: _uuid.v4(),
			firstName: firstName,
			lastName: lastName,
			dateOfBirth: dateOfBirth,
			email: email,
			phone: phone,
		);
		await box.put(student.id, student);
		return student;
	}

	Future<void> update(Student student) async {
		final box = await _openBox();
		await box.put(student.id, student);
	}

	Future<void> delete(String id) async {
		final box = await _openBox();
		await box.delete(id);
	}

	Future<Student?> getById(String id) async {
		final box = await _openBox();
		return box.get(id);
	}
}