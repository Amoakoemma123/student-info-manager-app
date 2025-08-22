import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/student.dart';
import '../../providers.dart';

class StudentDetailScreen extends ConsumerWidget {
	final String studentId;
	const StudentDetailScreen({super.key, required this.studentId});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final repo = ref.read(studentRepositoryProvider);
		return FutureBuilder<Student?>(
			future: repo.getById(studentId),
			builder: (context, snapshot) {
				if (!snapshot.hasData) {
					return const Scaffold(body: Center(child: CircularProgressIndicator()));
				}
				final student = snapshot.data;
				if (student == null) {
					return const Scaffold(body: Center(child: Text('Student not found')));
				}
				return Scaffold(
					appBar: AppBar(title: const Text('Student Details')),
					body: Padding(
						padding: const EdgeInsets.all(16),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text('${student.firstName} ${student.lastName}', style: Theme.of(context).textTheme.headlineSmall),
								const SizedBox(height: 8),
								Text('Email: ${student.email}'),
								Text('Phone: ${student.phone}'),
							],
						),
					),
				);
			},
		);
	}
}