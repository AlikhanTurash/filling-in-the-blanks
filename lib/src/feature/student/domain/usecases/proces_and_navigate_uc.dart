import 'package:fitb_pantry_app/src/feature/student/data/remote/repository/student_remote_repository.dart';

class AddStudentUC {
  final StudentRemoteRepository repository;

  AddStudentUC(this.repository);

  Future<void> call(Map<String, dynamic> dataToSave) async {
    await repository.addStudent(dataToSave);
  }
}
