import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/students/students_list_screen.dart';
import 'features/students/student_form_screen.dart';
import 'features/students/student_detail_screen.dart';
import 'features/courses/courses_list_screen.dart';
import 'features/courses/course_form_screen.dart';
import 'features/enrollments/enrollments_list_screen.dart';

final appRouter = GoRouter(
	routes: <RouteBase>[
		GoRoute(
			path: '/',
			builder: (context, state) => const _HomeScreen(),
		),
		GoRoute(
			path: '/students',
			builder: (context, state) => const StudentsListScreen(),
		),
		GoRoute(
			path: '/students/new',
			builder: (context, state) => const StudentFormScreen(),
		),
		GoRoute(
			path: '/students/:id',
			builder: (context, state) => StudentDetailScreen(studentId: state.pathParameters['id']!),
		),
		GoRoute(
			path: '/students/:id/edit',
			builder: (context, state) => StudentFormScreen(studentId: state.pathParameters['id']!),
		),
		GoRoute(
			path: '/courses',
			builder: (context, state) => const CoursesListScreen(),
		),
		GoRoute(
			path: '/courses/new',
			builder: (context, state) => const CourseFormScreen(),
		),
		GoRoute(
			path: '/courses/:id/edit',
			builder: (context, state) => CourseFormScreen(courseId: state.pathParameters['id']),
		),
		GoRoute(
			path: '/enrollments',
			builder: (context, state) => const EnrollmentsListScreen(),
		),
	],
);

class _HomeScreen extends StatelessWidget {
	const _HomeScreen();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Student Info Manager')),
			body: Center(
				child: Wrap(
					spacing: 16,
					runSpacing: 16,
					children: [
						_EntryButton(label: 'Students', route: '/students'),
						_EntryButton(label: 'Courses', route: '/courses'),
						_EntryButton(label: 'Enrollments', route: '/enrollments'),
					],
				),
			),
		);
	}
}

class _EntryButton extends StatelessWidget {
	final String label;
	final String route;
	const _EntryButton({required this.label, required this.route});

	@override
	Widget build(BuildContext context) {
		return ElevatedButton(
			onPressed: () => context.go(route),
			child: Text(label),
		);
	}
}