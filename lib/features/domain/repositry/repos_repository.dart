import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/repo_entity.dart';

abstract class ReposRepository {
  /// Returns cached repos from local storage (no Either — never fails to UI)
  Future<List<RepoEntity>> getLocalRepos({
    required int skip,
    required int limit,
  });

  /// Fetches repos from remote API, returns Either of Failure or List of RepoEntity
  Future<Either<Failure, List<RepoEntity>>> getRepos({
    required int skip,
    required int limit,
  });
}
