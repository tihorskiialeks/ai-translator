import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<TState> extends Cubit<TState> {
  BaseCubit(super.initialState);

  void handleError(String errorMessage);

  void emitIfNotClosed(TState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  Future<void> makeErrorHandledCall(AsyncCallback callback) async {
    try {
      await callback();
    } catch (exception, _) {
      handleError(exception.toString());
    }
  }
}
