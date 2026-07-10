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
      context.read<RepoCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RepoCubit, RepoState>(
      builder: (context, state) {
        return switch (state) {
          ReposInitial() || ReposLoading() => _buildSkeletonList(),
          ReposFailure(:final errMessage) =>
            _buildErrorWidget(context, errMessage),
          ReposSuccess(:final repos) => repos.isEmpty
              ? Center(
                  child: Text(
                    'No repositories found.',
                    style: AppStyles.bodyLarge,
                  ),
                )
              : _buildList(context, repos),
        };
      },
    );
  }

  Widget _buildList(BuildContext context, List<RepoEntity> repos) {
    final cubit = context.read<RepoCubit>();

    return RefreshIndicator(
      onRefresh: () => cubit.getRepos(refresh: true),
      color: AppColors.primary,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: repos.length + (cubit.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= repos.length) {
            return _buildPaginationLoader();
          }
          return RepoCard(repo: repos[index]);
        },
      ),
    );
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
        itemBuilder: (context, index) => RepoCard(repo: dummyRepos[index]),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
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
              message,
              style: AppStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => context.read<RepoCubit>().getRepos(refresh: true),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationLoader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
