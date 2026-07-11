import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/repo_entity.dart';
import '../../domain/usecase/get_repo.dart';
import 'repo_state.dart';

class RepoCubit extends Cubit<RepoState> {
  RepoCubit({
    required this.getReposUseCase,
  }) : super(const ReposInitial());

  final GetReposUseCase getReposUseCase;

  int skip = 0;
  final int limit = 10;

  List<RepoEntity> repos = [];
  String searchQuery = '';

  bool isLoadingMore = false;
  bool hasMore = true;

  List<RepoEntity> get _displayedRepos {
    if (searchQuery.isEmpty) {
      return List.from(repos);
    }
    final q = searchQuery.toLowerCase();
    return repos.where((repo) {
      final name = repo.name.toLowerCase();
      final description = repo.description.toLowerCase();
      final owner = repo.owner.login.toLowerCase();
      return name.contains(q) || description.contains(q) || owner.contains(q);
    }).toList();
  }

  void search(String query) {
    searchQuery = query;
    emit(ReposSuccess(_displayedRepos));
  }

  Future<void> getRepos({bool refresh = false}) async {
    if (refresh) {
      skip = 0;
      repos.clear();
      hasMore = true;
    }

    emit(const ReposLoading());

    final result = await getReposUseCase(
      skip: skip,
      limit: limit,
    );

    result.fold(
      (failure) {
        emit(ReposFailure(failure.errMessage));
      },
      (data) {
        repos = List.from(data);
        skip = repos.length;

        if (data.length < limit) {
          hasMore = false;
        }

        emit(ReposSuccess(_displayedRepos));
      },
    );
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;

    final result = await getReposUseCase(
      skip: skip,
      limit: limit,
    );

    result.fold(
      (failure) {
        isLoadingMore = false;
        // Keep existing data but allow retrying
      },
      (data) {
        repos.addAll(data);
        skip = repos.length;

        if (data.length < limit) {
          hasMore = false;
        }

        isLoadingMore = false;
        emit(ReposSuccess(_displayedRepos));
      },
    );
  }
}