import 'package:hive/hive.dart';

part 'course.g.dart';

@HiveType(typeId: 2)
class Course {
	@HiveField(0)
	final String id;

	@HiveField(1)
	final String code;

	@HiveField(2)
	final String title;

	@HiveField(3)
	final int creditHours;

	Course({
		required this.id,
		required this.code,
		required this.title,
		required this.creditHours,
	});
}