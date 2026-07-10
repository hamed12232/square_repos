import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/repo_entity.dart';
import '../../domain/repositry/repos_repository.dart';
import '../data_source/local/repos_local_data_source.dart';
import '../data_source/remote/repos_remote_data_source.dart';

class ReposRepositoryImpl implements ReposRepository {
  final ReposRemoteDataSource remoteDataSource;
  final ReposLocalDataSource localDataSource;

  const ReposRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<RepoEntity>> getLocalRepos({
    required int skip,
    required int limit,
  }) async {
    try {
      return await localDataSource.getReposs(skip: skip, limit: limit);
    } catch (_) {
      return [];
    }
  }

  @override
  Future<Either<Failure, List<RepoEntity>>> getRepos({
    required int skip,
    required int limit,
  }) async {
    try {
      // Convert skip/limit to page number for the GitHub API
      final page = limit == 0 ? 1 : (skip ~/ limit) + 1;
      final remoteRepos = await remoteDataSource.getRepos(
        page: page,
        perPage: limit,
      );
      await localDataSource.saveRepossToCache(
        repos: remoteRepos,
        clear: skip == 0,
      );
      return Right(remoteRepos);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}