import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:square_repos/features/presentaion/widgets/repo_card.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../domain/entities/owner_entity.dart';
import '../../domain/entities/repo_entity.dart';
import '../cubit/repo_cubit.dart';
import '../cubit/repo_state.dart';

class RepoListView extends StatefulWidget {
  const RepoListView({super.key});

  @override
  State<RepoListView> createState() => RepoListViewState();
}

class RepoListViewState extends State<RepoListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200.h) {
      context.read<RepoCubit>().loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RepoCubit, RepoState>(
      listener: (context, state) {
        if (state is RepoLoaded && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is RepoInitial || (state is RepoLoading && _isEmpty(state))) {
          return _buildSkeletonList();
        }

        if (state is RepoError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 48.w,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    style: AppStyles.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<RepoCubit>().loadRepos(isRefresh: true),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        final repos = _getRepos(state);
        final hasReachedMax = _hasReachedMax(state);

        if (repos.isEmpty) {
          return Center(
            child: Text('No repositories found', style: AppStyles.bodyLarge),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<RepoCubit>().loadRepos(isRefresh: true),
          color: AppColors.primary,
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            itemCount: repos.length + (hasReachedMax ? 0 : 1),
            itemBuilder: (context, index) {
              if (index >= repos.length) {
                return _buildLoadingIndicator();
              }
              return RepoCard(repo: repos[index]);
            },
          ),
        );
      },
    );
  }

  bool _isEmpty(RepoState state) {
    if (state is RepoLoaded) return state.repos.isEmpty;
    return true;
  }

  List<RepoEntity> _getRepos(RepoState state) {
    if (state is RepoLoaded) return state.repos;
    return [];
  }

  bool _hasReachedMax(RepoState state) {
    if (state is RepoLoaded) return state.hasReachedMax;
    return true;
  }

  Widget _buildSkeletonList() {
    final dummyRepos = List.generate(
      8,
      (index) => RepoEntity(
        id: index,
        name: 'Skeleton Repository Name',
        description:
            'This is a mock description that represents the repository details.',
        fork: index % 3 == 0,
        htmlUrl: '',
        owner: const OwnerEntity(login: 'square', htmlUrl: ''),
      ),
    );

    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: dummyRepos.length,
        itemBuilder: (context, index) {
          return RepoCard(repo: dummyRepos[index]);
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
