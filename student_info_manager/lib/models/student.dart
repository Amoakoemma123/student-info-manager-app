import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 1)
class Student {
	@HiveField(0)
	final String id;

	@HiveField(1)
	final String firstName;

	@HiveField(2)
	final String lastName;

	@HiveField(3)
	final DateTime dateOfBirth;

	@HiveField(4)
	final String email;

	@HiveField(5)
	final String phone;

	Student({
		required this.id,
		required this.firstName,
		required this.lastName,
		required this.dateOfBirth,
		required this.email,
		required this.phone,
	});
}