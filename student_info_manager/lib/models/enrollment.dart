import 'package:hive/hive.dart';

part 'enrollment.g.dart';

@HiveType(typeId: 3)
class Enrollment {
	@HiveField(0)
	final String id;

	@HiveField(1)
	final String studentId;

	@HiveField(2)
	final String courseId;

	@HiveField(3)
	final DateTime enrolledOn;

	@HiveField(4)
	final String? grade; // optional grade (A, B, etc.)

	Enrollment({
		required this.id,
		required this.studentId,
		required this.courseId,
		required this.enrolledOn,
		this.grade,
	});
}