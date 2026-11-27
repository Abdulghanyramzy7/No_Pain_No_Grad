import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/policies/client_detail/cubit/client_detail_state.dart';
import 'client_detail_state.dart';

class ClientDetailCubit extends Cubit<ClientDetailState> {
  static const List<int> _allowedMonths = [1, 3, 6, 12];

  ClientDetailCubit(int initialMonths)
      : super(ClientDetailState(durationMonths: initialMonths));

  void decrease() {
    final i = _allowedMonths.indexOf(state.durationMonths);
    if (i > 0) {
      emit(ClientDetailState(durationMonths: _allowedMonths[i - 1]));
    }
  }

  void increase() {
    final i = _allowedMonths.indexOf(state.durationMonths);
    if (i < _allowedMonths.length - 1) {
      emit(ClientDetailState(durationMonths: _allowedMonths[i + 1]));
    }
  }

  void markUpdated() {
    emit(ClientDetailState(
      durationMonths: state.durationMonths,
      isDurationUpdated: true,
    ));
  }
}