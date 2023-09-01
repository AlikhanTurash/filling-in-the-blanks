import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_dto.g.dart';
part 'student_dto.freezed.dart';

@freezed
class StudentDTO with _$StudentDTO {
  const factory StudentDTO(
      {required String firstName,
      required String lastName,
      required String email,
      required String phoneNumber,
      required String schoolNae}) = _StudentDTO;
  factory StudentDTO.fromJson(Map<String, dynamic> json) =>
      _$StudentDTOFromJson(json);
}
