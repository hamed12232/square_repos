import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../domain/entities/owner_entity.dart';
import '../../domain/entities/repo_entity.dart';
import 'repo_card.dart';

class RepoSkeletonList extends StatelessWidget {
  const RepoSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
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
}
