import 'package:equatable/equatable.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class ChangeCategory extends FilterEvent {
  final String category;

  const ChangeCategory(this.category);

  @override
  List<Object?> get props => [category];
}
