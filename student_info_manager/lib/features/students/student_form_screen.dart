import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../models/student.dart';
import '../../providers.dart';

class StudentFormScreen extends ConsumerStatefulWidget {
	final String? studentId;
	const StudentFormScreen({super.key, this.studentId});

	@override
	ConsumerState<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends ConsumerState<StudentFormScreen> {
	final _formKey = GlobalKey<FormState>();
	final _firstNameController = TextEditingController();
	final _lastNameController = TextEditingController();
	final _emailController = TextEditingController();
	final _phoneController = TextEditingController();
	DateTime? _dob;
	Student? _existing;
	bool _loading = true;

	@override
	void initState() {
		super.initState();
		Future.microtask(() async {
			final repo = ref.read(studentRepositoryProvider);
			if (widget.studentId != null) {
				_existing = await repo.getById(widget.studentId!);
				if (_existing != null) {
					_firstNameController.text = _existing!.firstName;
					_lastNameController.text = _existing!.lastName;
					_emailController.text = _existing!.email;
					_phoneController.text = _existing!.phone;
					_dob = _existing!.dateOfBirth;
				}
			}
			setState(() => _loading = false);
		});
	}

	@override
	void dispose() {
		_firstNameController.dispose();
		_lastNameController.dispose();
		_emailController.dispose();
		_phoneController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: Text(widget.studentId == null ? 'Add Student' : 'Edit Student')),
			body: _loading
					? const Center(child: CircularProgressIndicator())
					: Form(
						key: _formKey,
						child: ListView(
							padding: const EdgeInsets.all(16),
							children: [
								TextFormField(
									controller: _firstNameController,
									decoration: const InputDecoration(labelText: 'First Name'),
									validator: (v) => v == null || v.isEmpty ? 'Required' : null,
								),
								TextFormField(
									controller: _lastNameController,
									decoration: const InputDecoration(labelText: 'Last Name'),
									validator: (v) => v == null || v.isEmpty ? 'Required' : null,
								),
								TextFormField(
									controller: _emailController,
									decoration: const InputDecoration(labelText: 'Email'),
									validator: (v) => v == null || v.isEmpty ? 'Required' : null,
								),
								TextFormField(
									controller: _phoneController,
									decoration: const InputDecoration(labelText: 'Phone'),
									validator: (v) => v == null || v.isEmpty ? 'Required' : null,
								),
								ListTile(
									title: Text(_dob == null ? 'Select Date of Birth' : DateFormat.yMMMd().format(_dob!)),
									trailing: const Icon(Icons.calendar_today),
									onTap: () async {
										final now = DateTime.now();
										final picked = await showDatePicker(
											context: context,
											initialDate: _dob ?? DateTime(now.year - 18, now.month, now.day),
											firstDate: DateTime(1900),
											lastDate: now,
										);
										if (picked != null) setState(() => _dob = picked);
									},
								),
								const SizedBox(height: 16),
								ElevatedButton.icon(
									icon: const Icon(Icons.save),
									label: const Text('Save'),
									onPressed: () async {
										if (!_formKey.currentState!.validate() || _dob == null) return;
										final repo = ref.read(studentRepositoryProvider);
										if (_existing == null) {
											await repo.create(
												firstName: _firstNameController.text,
												lastName: _lastNameController.text,
												dateOfBirth: _dob!,
												email: _emailController.text,
												phone: _phoneController.text,
											);
										} else {
											await repo.update(Student(
												id: _existing!.id,
												firstName: _firstNameController.text,
												lastName: _lastNameController.text,
												dateOfBirth: _dob!,
												email: _emailController.text,
												phone: _phoneController.text,
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