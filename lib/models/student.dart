class Student {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String dateOfBirth;
  final String gender;
  final String course;
  final String year;
  final String semester;
  final String profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.dateOfBirth,
    required this.gender,
    required this.course,
    required this.year,
    required this.semester,
    this.profileImage = '',
    required this.createdAt,
    required this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      gender: json['gender'] ?? '',
      course: json['course'] ?? '',
      year: json['year'] ?? '',
      semester: json['semester'] ?? '',
      profileImage: json['profileImage'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'course': course,
      'year': year,
      'semester': semester,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Student copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? dateOfBirth,
    String? gender,
    String? course,
    String? year,
    String? semester,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      course: course ?? this.course,
      year: year ?? this.year,
      semester: semester ?? this.semester,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Student(id: $id, name: $name, email: $email, course: $course, year: $year)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Student && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}