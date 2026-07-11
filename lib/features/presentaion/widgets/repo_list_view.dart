import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:square_repos/features/presentaion/widgets/repo_card.dart';
import 'package:square_repos/features/presentaion/widgets/search_text_field.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../domain/entities/repo_entity.dart';
import '../cubit/repo_cubit.dart';
import '../cubit/repo_state.dart';
import 'repo_error_widget.dart';
import 'repo_pagination_loader.dart';
import 'repo_skeleton_list.dart';

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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: SearchTextField(),
        ),
        Expanded(
          child: BlocBuilder<RepoCubit, RepoState>(
            builder: (context, state) {
              return switch (state) {
                ReposInitial() || ReposLoading() => const RepoSkeletonList(),
                ReposFailure(:final errMessage) => RepoErrorWidget(
                    message: errMessage,
                    onRetry: () =>
                        context.read<RepoCubit>().getRepos(refresh: true),
                  ),
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
          ),
        ),
      ],
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
            return const RepoPaginationLoader();
          }
          return RepoCard(repo: repos[index]);
        },
      ),
    );
  }
}

