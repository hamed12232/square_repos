import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/repo_entity.dart';
import '../../domain/repositry/repos_repository.dart';
import '../data_source/local/repos_local_data_source.dart';
import '../data_source/remote/repos_remote_data_source.dart';
import '../model/owner_model.dart';
import '../model/repo_model.dart';

class ReposRepositoryImpl implements ReposRepository {
  final ReposRemoteDataSource remoteDataSource;
  final ReposLocalDataSource localDataSource;

  const ReposRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });


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
    } catch (e) {
      try {
        final localRepos = await localDataSource.getReposs(skip: skip, limit: limit);
        if (localRepos.isNotEmpty) {
          return Right(localRepos);
        }
      } catch (_) {
        // Fall through to return the original error if cache reading fails
      }

      if (e is ServerException) {
        return Left(ServerFailure(e.errorMessageModel.statusMessage));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RepoEntity>>> getRemoteRepos({
    required int page,
    required int perPage,
  }) async {
    try {
      final remoteRepos = await remoteDataSource.getRepos(
        page: page,
        perPage: perPage,
      );
      return Right(remoteRepos);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<List<RepoEntity>> getCachedRepos() async {
    try {
      return await localDataSource.getReposs(skip: 0, limit: 1000);
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveReposToCache(List<RepoEntity> repos, {bool clear = false}) async {
    try {
      final List<RepoModel> repoModels = repos.map((e) => RepoModel(
        id: e.id,
        name: e.name,
        description: e.description,
        fork: e.fork,
        htmlUrl: e.htmlUrl,
        owner: OwnerModel(
          login: e.owner.login,
          htmlUrl: e.owner.htmlUrl,
        ),
      )).toList();
      await localDataSource.saveRepossToCache(
        repos: repoModels,
        clear: clear,
      );
    } catch (_) {
      // Ignore or log error
    }
  }
}