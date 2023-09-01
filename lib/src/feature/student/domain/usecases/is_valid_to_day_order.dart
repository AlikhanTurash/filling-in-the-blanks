import 'package:fitb_pantry_app/src/feature/student/data/remote/repository/student_remote_repository.dart';

class IsTodayValidOrderDayUC {
  final StudentRemoteRepository repository;

  IsTodayValidOrderDayUC(this.repository);

  Future<bool> call(String schoolId) async {
    return await repository.isTodayValidOrderDay(schoolId);
  }
}
