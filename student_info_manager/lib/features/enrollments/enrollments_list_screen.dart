import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/enrollment.dart';
import '../../providers.dart';

class EnrollmentsListScreen extends ConsumerWidget {
	const EnrollmentsListScreen({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final asyncBox = ref.watch(enrollmentsBoxProvider);
		final repo = ref.read(enrollmentRepositoryProvider);
		return Scaffold(
			appBar: AppBar(title: const Text('Enrollments')),
			body: asyncBox.when(
				data: (_) => FutureBuilder<List<Enrollment>>(
					future: repo.getAll(),
					builder: (context, snapshot) {
						if (!snapshot.hasData) {
							return const Center(child: CircularProgressIndicator());
						}
						final enrollments = snapshot.data!;
						if (enrollments.isEmpty) {
							return const Center(child: Text('No enrollments yet'));
						}
						return ListView.separated(
							itemCount: enrollments.length,
							separatorBuilder: (_, __) => const Divider(height: 1),
							itemBuilder: (context, index) {
								final e = enrollments[index];
								return ListTile(
									title: Text('Student: ${e.studentId}'),
									subtitle: Text('Course: ${e.courseId}  Grade: ${e.grade ?? '-'}'),
								);
							},
						);
					},
				),
				loading: () => const Center(child: CircularProgressIndicator()),
				error: (e, st) => Center(child: Text('Error: $e')),
			),
			floatingActionButton: FloatingActionButton.extended(
				onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EnrollmentFormScreen())),
				icon: const Icon(Icons.add),
				label: const Text('Add Enrollment'),
			),
		);
	}
}

class EnrollmentFormScreen extends ConsumerStatefulWidget {
	const EnrollmentFormScreen({super.key});

	@override
	ConsumerState<EnrollmentFormScreen> createState() => _EnrollmentFormScreenState();
}

class _EnrollmentFormScreenState extends ConsumerState<EnrollmentFormScreen> {
	final _formKey = GlobalKey<FormState>();
	String? _studentId;
	String? _courseId;
	String? _grade;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Add Enrollment')),
			body: Form(
				key: _formKey,
				child: ListView(
					padding: const EdgeInsets.all(16),
					children: [
						FutureBuilder(
							future: ref.read(studentRepositoryProvider).getAll(),
							builder: (context, snapshot) {
								final students = snapshot.data ?? [];
								return DropdownButtonFormField<String>(
									items: students.map((s) => DropdownMenuItem(value: s.id, child: Text('${s.firstName} ${s.lastName}'))).toList(),
									initialValue: _studentId,
									onChanged: (v) => setState(() => _studentId = v),
									decoration: const InputDecoration(labelText: 'Student'),
									validator: (v) => v == null ? 'Select a student' : null,
								);
							},
						),
						FutureBuilder(
							future: ref.read(courseRepositoryProvider).getAll(),
							builder: (context, snapshot) {
								final courses = snapshot.data ?? [];
								return DropdownButtonFormField<String>(
									items: courses.map((c) => DropdownMenuItem(value: c.id, child: Text('${c.code} - ${c.title}'))).toList(),
									initialValue: _courseId,
									onChanged: (v) => setState(() => _courseId = v),
									decoration: const InputDecoration(labelText: 'Course'),
									validator: (v) => v == null ? 'Select a course' : null,
								);
							},
						),
						TextFormField(
							decoration: const InputDecoration(labelText: 'Grade (optional)'),
							onChanged: (v) => _grade = v.isEmpty ? null : v,
						),
						const SizedBox(height: 16),
						ElevatedButton.icon(
							icon: const Icon(Icons.save),
							label: const Text('Save'),
							onPressed: () async {
								if (!_formKey.currentState!.validate()) return;
								await ref.read(enrollmentRepositoryProvider).create(
									studentId: _studentId!,
									courseId: _courseId!,
									enrolledOn: DateTime.now(),
									grade: _grade,
								);
								if (context.mounted) Navigator.of(context).pop();
							},
						),
					],
				),
			),
		);
	}
}