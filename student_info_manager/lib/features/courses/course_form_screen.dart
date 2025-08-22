import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/course.dart';
import '../../providers.dart';

class CourseFormScreen extends ConsumerStatefulWidget {
	final String? courseId;
	const CourseFormScreen({super.key, this.courseId});

	@override
	ConsumerState<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends ConsumerState<CourseFormScreen> {
	final _formKey = GlobalKey<FormState>();
	final _codeController = TextEditingController();
	final _titleController = TextEditingController();
	final _creditsController = TextEditingController();
	Course? _existing;
	bool _loading = true;

	@override
	void initState() {
		super.initState();
		Future.microtask(() async {
			final repo = ref.read(courseRepositoryProvider);
			if (widget.courseId != null) {
				_existing = await repo.getById(widget.courseId!);
				if (_existing != null) {
					_codeController.text = _existing!.code;
					_titleController.text = _existing!.title;
					_creditsController.text = _existing!.creditHours.toString();
				}
			}
			setState(() => _loading = false);
		});
	}

	@override
	void dispose() {
		_codeController.dispose();
		_titleController.dispose();
		_creditsController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: Text(widget.courseId == null ? 'Add Course' : 'Edit Course')),
			body: _loading
					? const Center(child: CircularProgressIndicator())
					: Form(
						key: _formKey,
						child: ListView(
							padding: const EdgeInsets.all(16),
							children: [
								TextFormField(
									controller: _codeController,
									decoration: const InputDecoration(labelText: 'Code'),
									validator: (v) => v == null || v.isEmpty ? 'Required' : null,
								),
								TextFormField(
									controller: _titleController,
									decoration: const InputDecoration(labelText: 'Title'),
									validator: (v) => v == null || v.isEmpty ? 'Required' : null,
								),
								TextFormField(
									controller: _creditsController,
									decoration: const InputDecoration(labelText: 'Credit Hours'),
									keyboardType: TextInputType.number,
									validator: (v) {
										if (v == null || v.isEmpty) return 'Required';
										final n = int.tryParse(v);
										if (n == null || n <= 0) return 'Enter a positive number';
										return null;
									},
								),
								const SizedBox(height: 16),
								ElevatedButton.icon(
									icon: const Icon(Icons.save),
									label: const Text('Save'),
									onPressed: () async {
										if (!_formKey.currentState!.validate()) return;
										final repo = ref.read(courseRepositoryProvider);
										final credits = int.parse(_creditsController.text);
										if (_existing == null) {
											await repo.create(
												code: _codeController.text,
												title: _titleController.text,
												creditHours: credits,
											);
										} else {
											await repo.update(Course(
												id: _existing!.id,
												code: _codeController.text,
												title: _titleController.text,
												creditHours: credits,
											));
										}
										if (context.mounted) context.pop();
									},
								),
							],
						),
					),
		);
	}
}