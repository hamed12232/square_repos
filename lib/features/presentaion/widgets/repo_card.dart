import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:square_repos/core/theme/app_colors.dart';
import 'package:square_repos/core/theme/app_styles.dart';
import 'package:square_repos/features/domain/entities/repo_entity.dart';

class RepoCard extends StatelessWidget {
  final RepoEntity repo;

  const RepoCard({super.key, required this.repo});

  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final Uri url = Uri.parse(urlString);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Safely ignore launcher exceptions
    }
  }

  void _showOpenLinkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Open in Browser'),
          content: const Text(
            'Select which link you would like to open:',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _launchUrl(repo.owner.htmlUrl);
              },
              child: const Text('Owner Profile'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _launchUrl(repo.htmlUrl);
              },
              child: const Text('Repository'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: !repo.fork ? const Color(0xFFE8F5E9) : Colors.white,
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onLongPress: () => _showOpenLinkDialog(context),
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
                        color: AppColors.success.withValues(alpha: 0.1),
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
      ),
    );
  }
}
