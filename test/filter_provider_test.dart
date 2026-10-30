import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolioweb/presentation/providers/filter_provider.dart';

void main() {
  test('blog and skills keep independent category selections', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final blog = categoryFilterProvider(FilterSection.blog);
    final skills = categoryFilterProvider(FilterSection.skills);
    container.listen(blog, (_, _) {});
    container.listen(skills, (_, _) {});

    expect(container.read(blog), 'All');
    expect(container.read(skills), 'All');

    container.read(blog.notifier).changeCategory('Flutter');
    expect(container.read(skills), 'All');

    container.read(skills.notifier).changeCategory('Mobile');
    expect(container.read(blog), 'Flutter');
    expect(container.read(skills), 'Mobile');

    container.read(blog.notifier).changeCategory('All');
    expect(container.read(blog), 'All');
    expect(container.read(skills), 'Mobile');
  });

  test('removing a section resets only its filter when it returns', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final blog = categoryFilterProvider(FilterSection.blog);
    final skills = categoryFilterProvider(FilterSection.skills);
    final blogSubscription = container.listen(blog, (_, _) {});
    container.listen(skills, (_, _) {});
    container.read(blog.notifier).changeCategory('Flutter');
    container.read(skills.notifier).changeCategory('Mobile');

    blogSubscription.close();
    await container.pump();

    container.listen(blog, (_, _) {});
    expect(container.read(blog), 'All');
    expect(container.read(skills), 'Mobile');
  });
}
