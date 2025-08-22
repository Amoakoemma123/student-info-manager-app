import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../providers/student_provider.dart';
import '../providers/auth_provider.dart';
import '../models/student.dart';
import '../utils/theme.dart';
import '../widgets/student_card.dart';
import 'student_detail_screen.dart';
import 'edit_student_screen.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StudentProvider, AuthProvider>(
      builder: (context, studentProvider, authProvider, child) {
        return Column(
          children: [
            _buildSearchAndFilters(studentProvider),
            Expanded(
              child: _buildStudentsList(studentProvider, authProvider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchAndFilters(StudentProvider studentProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search students...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  studentProvider.setSearchQuery('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              studentProvider.setSearchQuery(value);
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Course',
                    border: OutlineInputBorder(),
                  ),
                  value: studentProvider.filterCourse.isEmpty
                      ? null
                      : studentProvider.filterCourse,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('All Courses'),
                    ),
                    ...studentProvider.uniqueCourses.map((course) {
                      return DropdownMenuItem<String>(
                        value: course,
                        child: Text(course),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    studentProvider.setFilterCourse(value ?? '');
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(),
                  ),
                  value: studentProvider.filterYear.isEmpty
                      ? null
                      : studentProvider.filterYear,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('All Years'),
                    ),
                    ...studentProvider.uniqueYears.map((year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(year),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    studentProvider.setFilterYear(value ?? '');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Students: ${studentProvider.totalStudents}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Showing: ${studentProvider.filteredStudentsCount}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  studentProvider.clearFilters();
                  _searchController.clear();
                },
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear Filters'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsList(StudentProvider studentProvider, AuthProvider authProvider) {
    if (studentProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (studentProvider.filteredStudents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No students found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => studentProvider.loadStudents(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: studentProvider.filteredStudents.length,
        itemBuilder: (context, index) {
          final student = studentProvider.filteredStudents[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  if (authProvider.hasPermission('edit_students'))
                    SlidableAction(
                      onPressed: (_) => _editStudent(student),
                      backgroundColor: AppTheme.warningColor,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  if (authProvider.hasPermission('delete_students'))
                    SlidableAction(
                      onPressed: (_) => _deleteStudent(student),
                      backgroundColor: AppTheme.errorColor,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                ],
              ),
              child: StudentCard(
                student: student,
                onTap: () => _viewStudent(student),
              ),
            ),
          );
        },
      ),
    );
  }

  void _viewStudent(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetailScreen(student: student),
      ),
    );
  }

  void _editStudent(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStudentScreen(student: student),
      ),
    );
  }

  void _deleteStudent(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<StudentProvider>(context, listen: false)
                  .deleteStudent(student.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${student.name} deleted successfully'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}