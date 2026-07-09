import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/repo_entity.dart';
import '../repositry/repos_repository.dart';

class RefreshReposUseCase {
  final ReposRepository repository;

  const RefreshReposUseCase(this.repository);

  Stream<Either<Failure, List<RepoEntity>>> call({required int perPage}) {
    return repository.getRepos(page: 1, perPage: perPage);
  }
}
