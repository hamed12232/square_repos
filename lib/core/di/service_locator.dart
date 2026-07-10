import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:square_repos/core/constants/api_constant.dart';

import '../../features/data/data_source/local/repos_local_data_source.dart';
import '../../features/data/data_source/remote/repos_remote_data_source.dart';
import '../../features/data/repo/repos_repository_impl.dart';
import '../../features/domain/repositry/repos_repository.dart';
import '../../features/domain/usecase/get_repo.dart';
import '../../features/presentaion/cubit/repo_cubit.dart';
import '../services/local_database.dart';

final sl = GetIt.instance;

Future<void> init() async {

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );
  sl.registerLazySingleton<Dio>(() => dio);

  // Local Database Service
  sl.registerLazySingleton<LocalDataBaseService>(() => LocalDataBaseService());

  // =========================================================================
  // 2. DataSources
  // =========================================================================
  sl.registerLazySingleton<ReposRemoteDataSource>(
    () => ReposRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<ReposLocalDataSource>(
    () =>
        ReposLocalDataSource(localDataBaseService: sl<LocalDataBaseService>()),
  );

  // =========================================================================
  // 3. Repositories (MUST be LazySingleton)
  // =========================================================================
  sl.registerLazySingleton<ReposRepository>(
    () => ReposRepositoryImpl(
      remoteDataSource: sl<ReposRemoteDataSource>(),
      localDataSource: sl<ReposLocalDataSource>(),
    ),
  );

  // =========================================================================
  // 4. UseCases
  // =========================================================================
  sl.registerLazySingleton<GetReposUseCase>(
    () => GetReposUseCase(sl<ReposRepository>()),
  );

  // =========================================================================
  // 5. Cubits (MUST be Factory)
  // =========================================================================
  sl.registerFactory<RepoCubit>(
    () => RepoCubit(getReposUseCase: sl<GetReposUseCase>()),
  );
}
