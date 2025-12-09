import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(const FilterState(selectedCategory: 'All')) {
    on<ChangeCategory>(_onChangeCategory);
  }

  void _onChangeCategory(
    ChangeCategory event,
    Emitter<FilterState> emit,
  ) {
    emit(FilterState(selectedCategory: event.category));
  }
}
