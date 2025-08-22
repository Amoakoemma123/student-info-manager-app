import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bootstrap.dart';
import 'router.dart';

void main() {
	dartEntrypoint();
}

Future<void> dartEntrypoint() async {
	await bootstrapApp(() async => const ProviderScope(child: StudentInfoApp()));
}

class StudentInfoApp extends StatelessWidget {
	const StudentInfoApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp.router(
			title: 'Student Info Manager',
			theme: ThemeData(
				colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
			),
			routerConfig: appRouter,
		);
	}
}
