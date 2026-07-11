import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/repo_entity.dart';

abstract class ReposRepository {
  
  /// Fetches repos from remote API, returns Either of Failure or List of RepoEntity
  Future<Either<Failure, List<RepoEntity>>> getRepos({
    required int skip,
    required int limit,
  });

  /// Fetches fresh repos directly from remote API without caching
  Future<Either<Failure, List<RepoEntity>>> getRemoteRepos({
    required int page,
    required int perPage,
  });

  /// Reads all cached repos from the local database
  Future<List<RepoEntity>> getCachedRepos();

  /// Saves the given repos to the local cache database
  Future<void> saveReposToCache(List<RepoEntity> repos, {bool clear = false});
}
