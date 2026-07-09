import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/repo_entity.dart';
import '../repositry/repos_repository.dart';

class GetReposUseCase {
  final ReposRepository repository;

  const GetReposUseCase(this.repository);

  Stream<Either<Failure, List<RepoEntity>>> call({
    required int page,
    required int perPage,
  }) {
    return repository.getRepos(page: page, perPage: perPage);
  }
}
