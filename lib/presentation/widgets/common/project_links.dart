import 'package:flutter/material.dart';

import '../../../core/utils/url_helper.dart';
import '../../../data/models/project.dart';

class ProjectLinks extends StatelessWidget {
  const ProjectLinks({super.key, required this.project, this.compact = false});

  final Project project;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final links = [
      (project.github, 'Source code', Icons.code),
      (project.liveUrl, 'Live demo', Icons.open_in_new),
      (project.playStoreUrl, 'Google Play', Icons.android),
      (project.appStoreUrl, 'App Store', Icons.apple),
    ].where((link) => link.$1.isNotEmpty);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: links.map((link) {
        if (compact) {
          return IconButton.outlined(
            tooltip: link.$2,
            onPressed: () => UrlHelper.launchURL(link.$1),
            icon: Icon(link.$3, size: 18),
          );
        }
        return OutlinedButton.icon(
          onPressed: () => UrlHelper.launchURL(link.$1),
          icon: Icon(link.$3, size: 18),
          label: Text(link.$2),
        );
      }).toList(),
    );
  }
}
