import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/course.dart';
import '../../providers.dart';

class CoursesListScreen extends ConsumerWidget {
	const CoursesListScreen({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final asyncBox = ref.watch(coursesBoxProvider);
		final repo = ref.read(courseRepositoryProvider);
		return Scaffold(
			appBar: AppBar(title: const Text('Courses')),
			body: asyncBox.when(
				data: (_) => FutureBuilder<List<Course>>(
					future: repo.getAll(),
					builder: (context, snapshot) {
						if (!snapshot.hasData) {
							return const Center(child: CircularProgressIndicator());
						}
						final courses = snapshot.data!;
						if (courses.isEmpty) {
							return const Center(child: Text('No courses yet'));
						}
						return ListView.separated(
							itemCount: courses.length,
							separatorBuilder: (_, __) => const Divider(height: 1),
							itemBuilder: (context, index) {
								final c = courses[index];
								return ListTile(
									title: Text('${c.code} - ${c.title}'),
									subtitle: Text('Credits: ${c.creditHours}'),
									trailing: Row(
										mainAxisSize: MainAxisSize.min,
										children: [
											IconButton(
												icon: const Icon(Icons.edit),
												onPressed: () => context.go('/courses/${c.id}/edit'),
											),
											IconButton(
												icon: const Icon(Icons.delete),
												onPressed: () async {
												await repo.delete(c.id);
												ref.invalidate(coursesBoxProvider);
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
				onPressed: () => context.go('/courses/new'),
				icon: const Icon(Icons.add),
				label: const Text('Add Course'),
			),
		);
	}
}