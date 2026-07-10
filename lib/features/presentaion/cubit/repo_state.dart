import '../../domain/entities/repo_entity.dart';

sealed class RepoState {
  const RepoState();
}

final class ReposInitial extends RepoState {
  const ReposInitial();
}

final class ReposLoading extends RepoState {
  const ReposLoading();
}

final class ReposSuccess extends RepoState {
  final List<RepoEntity> repos;

  const ReposSuccess(this.repos);
}

final class ReposFailure extends RepoState {
  final String errMessage;

  const ReposFailure(this.errMessage);
}
