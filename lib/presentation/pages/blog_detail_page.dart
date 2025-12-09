import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BlogDetailPage extends StatelessWidget {
  final String slug;

  const BlogDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/')),
        title: const Text('Blog Post'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Blog Slug: $slug', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            const Text('Blog detail page - Coming soon'),
          ],
        ),
      ),
    );
  }
}
