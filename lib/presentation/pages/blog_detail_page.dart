import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/blog_post.dart';
import '../providers/portfolio_provider.dart';

final blogDetailProvider = FutureProvider.autoDispose.family<BlogPost?, String>(
  (ref, slug) => ref.watch(dataRepositoryProvider).getBlogPostBySlug(slug),
  retry: (retryCount, error) => null,
);

class BlogDetailPage extends ConsumerWidget {
  final String slug;

  const BlogDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(blogDetailProvider(slug));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Blog Post'),
      ),
      body: post.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Could not load this post.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(dataRepositoryProvider).clearCache();
                  ref.invalidate(blogDetailProvider(slug));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (post) => post == null
            ? const Center(child: Text('Blog post not found.'))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${post.author} · ${post.readTime}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        if (post.coverImage.isNotEmpty) ...[
                          Image.network(
                            post.coverImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) =>
                                const Icon(Icons.image_not_supported_outlined),
                          ),
                          const SizedBox(height: 24),
                        ],
                        SelectableText(
                          post.content,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(height: 1.7),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: post.tags
                              .map((tag) => Chip(label: Text(tag)))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
