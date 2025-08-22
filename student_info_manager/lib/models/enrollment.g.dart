// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnrollmentAdapter extends TypeAdapter<Enrollment> {
  @override
  final int typeId = 3;

  @override
  Enrollment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Enrollment(
      id: fields[0] as String,
      studentId: fields[1] as String,
      courseId: fields[2] as String,
      enrolledOn: fields[3] as DateTime,
      grade: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Enrollment obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.courseId)
      ..writeByte(3)
      ..write(obj.enrolledOn)
      ..writeByte(4)
      ..write(obj.grade);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnrollmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
