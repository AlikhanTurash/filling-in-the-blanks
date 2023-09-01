import 'package:dio/dio.dart';
import 'package:fitb_pantry_app/src/core/network/layers/network_connectivity.dart';
import 'package:fitb_pantry_app/src/core/network/layers/network_creator.dart';
import 'package:fitb_pantry_app/src/core/network/layers/network_decoder.dart';
import 'package:fitb_pantry_app/src/core/network/layers/network_executer.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
Future<void> initLocator()async{
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