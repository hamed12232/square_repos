import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/repo_entity.dart';
import '../repositry/repos_repository.dart';

class GetReposUseCase {
  final ReposRepository repository;

  const GetReposUseCase(this.repository);

  Future<Either<Failure, List<RepoEntity>>> call({
    required int skip,
    required int limit,
  }) {
    return repository.getRepos(skip: skip, limit: limit);
  }
}
