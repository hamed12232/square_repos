import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:square_repos/core/theme/app_colors.dart';
import 'package:square_repos/core/theme/app_styles.dart';
import 'package:square_repos/features/domain/entities/repo_entity.dart';

class RepoCard extends StatelessWidget {
  final RepoEntity repo;

  const RepoCard({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    repo.name,
                    style: AppStyles.title.copyWith(
                      color: AppColors.primary,
                      fontSize: 16.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (repo.fork)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.fork_right_rounded,
                          size: 12.w,
                          color: AppColors.accent,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Fork',
                          style: AppStyles.labelMedium.copyWith(
                            color: AppColors.accent,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              repo.description.isEmpty
                  ? 'No description provided.'
                  : repo.description,
              style: AppStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  size: 14.w,
                  color: AppColors.textSecondaryLight,
                ),
                SizedBox(width: 6.w),
                Text(
                  repo.owner.login,
                  style: AppStyles.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
