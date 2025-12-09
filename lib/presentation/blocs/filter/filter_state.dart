import 'package:equatable/equatable.dart';

class FilterState extends Equatable {
  final String selectedCategory;

  const FilterState({required this.selectedCategory});

  @override
  List<Object?> get props => [selectedCategory];
}
