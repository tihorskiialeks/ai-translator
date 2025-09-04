
import 'package:equatable/equatable.dart';

enum TranslatorStatus { idle, loading, error, success;

bool get isLoading => this == TranslatorStatus.loading;
bool get isError => this == TranslatorStatus.error;
}

class TranslatorState extends Equatable {
  final TranslatorStatus status;
  final String errorMessage;
  final String result;

  const TranslatorState({
    this.status = TranslatorStatus.idle,
    this.errorMessage = '',
    this.result = '',
  });

  @override
  List<Object> get props => [status, errorMessage, result];

  TranslatorState copyWith({
    TranslatorStatus? status,
    String? errorMessage,
    String? result,
  }) {
    return TranslatorState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      result: result ?? this.result,
    );
  }
}
