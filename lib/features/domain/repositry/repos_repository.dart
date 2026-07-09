import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/repo_entity.dart';

abstract class ReposRepository {
  Stream<Either<Failure, List<RepoEntity>>> getRepos({
    required int page,
    required int perPage,
  });
}
