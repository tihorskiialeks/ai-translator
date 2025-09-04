import 'dart:typed_data';

import 'package:ai_training/cubit/core/base_cubit.dart';
import 'package:ai_training/cubit/translator_state.dart';
import 'package:ai_training/services/ai_translator_service.dart';

class TranslatorCubit extends BaseCubit<TranslatorState> {
  final AiTranslatorService _aiTranslatorService;
  TranslatorCubit(this._aiTranslatorService) : super(const TranslatorState());

  @override
  void handleError(String errorMessage) {
    emit(state.copyWith(
        status: TranslatorStatus.error, errorMessage: errorMessage.replaceAll('Exception:', '')));
  }

  Future<void> recognizeAndTranslate(Uint8List image) async {
    await makeErrorHandledCall(() async {
      emit(state.copyWith(status: TranslatorStatus.loading));

     
      final result =
          await _aiTranslatorService.recognizeAndTranslate('', image);
      emit(state.copyWith(result: result, status: TranslatorStatus.success));

       emit(state.copyWith(status: TranslatorStatus.success));
    });
  }
}
