import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/project.dart';
import '../providers/portfolio_provider.dart';
import '../widgets/common/project_links.dart';

final projectDetailProvider = FutureProvider.autoDispose
    .family<Project?, String>(
      (ref, id) => ref.watch(dataRepositoryProvider).getProjectById(id),
      retry: (retryCount, error) => null,
    );

class ProjectDetailPage extends ConsumerWidget {
  const ProjectDetailPage({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectDetailProvider(projectId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Project Details'),
      ),
      body: project.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Could not load this project.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(dataRepositoryProvider).clearCache();
                  ref.invalidate(projectDetailProvider(projectId));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (project) => project == null
            ? const Center(child: Text('Project not found.'))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.title,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          project.subtitle,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 24),
                        if (project.image.isNotEmpty) ...[
                          Image.network(
                            project.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) =>
                                const Icon(Icons.image_not_supported_outlined),
                          ),
                          const SizedBox(height: 24),
                        ],
                        SelectableText(
                          project.longDescription,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(height: 1.6),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: project.technologies
                              .map((name) => Chip(label: Text(name)))
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        ProjectLinks(project: project),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
