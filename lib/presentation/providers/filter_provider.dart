import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FilterSection { skills, blog }

/// Keeps each section's selection independent and resets it when unused.
final categoryFilterProvider = NotifierProvider.autoDispose
    .family<CategoryFilterNotifier, String, FilterSection>(
      CategoryFilterNotifier.new,
    );

class CategoryFilterNotifier extends Notifier<String> {
  CategoryFilterNotifier(this.section);

  final FilterSection section;

  @override
  String build() => 'All';

  void changeCategory(String category) {
    state = category;
  }
}
