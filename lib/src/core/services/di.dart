import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:fitb_pantry_app/src/core/network/layers/network_connectivity.dart';
import 'package:fitb_pantry_app/src/core/network/layers/network_creator.dart';
import 'package:fitb_pantry_app/src/core/network/layers/network_decoder.dart';
import 'package:fitb_pantry_app/src/core/network/layers/network_executer.dart';
import 'package:fitb_pantry_app/src/feature/student/data/remote/repository/student_remote_repository.dart';
import 'package:get_it/get_it.dart';

import '../../feature/student/domain/usecases/is_valid_to_day_order.dart';
import '../../feature/student/domain/usecases/proces_and_navigate_uc.dart';

final sl = GetIt.instance;
Future<void> initLocator() async {
  //SERVICES

  //USE CASES
  sl.registerLazySingleton(() => AddStudentUC(sl()));
  sl.registerLazySingleton(() => IsTodayValidOrderDayUC(sl()));

//REPOSITORIES
  sl.registerLazySingleton<StudentRemoteRepository>(
      () => StudentRepositoryImpl());

  //CORE
  sl.registerLazySingleton(() => Dio());

  sl.registerLazySingleton(() => NetworkExecuter(
        creator: sl(),
        decoder: sl(),
        dio: sl(),
        networkConnectivity: sl(),
      ));
  sl.registerLazySingleton(() => NetworkCreator());
  sl.registerLazySingleton(() => NetworkDecoder());
  sl.registerLazySingleton(() => NetworkConnectivity());
}
