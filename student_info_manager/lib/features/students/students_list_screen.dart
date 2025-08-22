import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/student.dart';
import '../../providers.dart';

class StudentsListScreen extends ConsumerWidget {
	const StudentsListScreen({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final asyncBox = ref.watch(studentsBoxProvider);
		final repo = ref.read(studentRepositoryProvider);
		return Scaffold(
			appBar: AppBar(title: const Text('Students')),
			body: asyncBox.when(
				data: (_) => FutureBuilder<List<Student>>(
					future: repo.getAll(),
					builder: (context, snapshot) {
						if (!snapshot.hasData) {
							return const Center(child: CircularProgressIndicator());
						}
						final students = snapshot.data!;
						if (students.isEmpty) {
							return const Center(child: Text('No students yet'));
						}
						return ListView.separated(
							itemCount: students.length,
							separatorBuilder: (_, __) => const Divider(height: 1),
							itemBuilder: (context, index) {
								final s = students[index];
								return ListTile(
									title: Text('${s.firstName} ${s.lastName}'),
									subtitle: Text(s.email),
									onTap: () => context.go('/students/${s.id}'),
									trailing: Row(
										mainAxisSize: MainAxisSize.min,
										children: [
											IconButton(
												icon: const Icon(Icons.edit),
												onPressed: () => context.go('/students/${s.id}/edit'),
											),
											IconButton(
												icon: const Icon(Icons.delete),
												onPressed: () async {
												await repo.delete(s.id);
												ref.invalidate(studentsBoxProvider);
											},
											),
										],
									),
								);
							},
						);
					},
				),
				loading: () => const Center(child: CircularProgressIndicator()),
				error: (e, st) => Center(child: Text('Error: $e')),
			),
			floatingActionButton: FloatingActionButton.extended(
				onPressed: () => context.go('/students/new'),
				icon: const Icon(Icons.add),
				label: const Text('Add Student'),
			),
		);
	}
}