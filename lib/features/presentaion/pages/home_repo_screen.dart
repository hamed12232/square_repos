import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:square_repos/features/presentaion/widgets/repo_list_view.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../cubit/repo_cubit.dart';

class HomeRepoScreen extends StatelessWidget {
  const HomeRepoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RepoCubit>()..loadRepos(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Square Repositories', style: AppStyles.title),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.h),
            child: Divider(
              height: 1.h,
              thickness: 1.h,
              color: AppColors.borderLight,
            ),
          ),
        ),
        body: const RepoListView(),
      ),
    );
  }
}
