// lib/data/repositories/result_model.dart

class RepositoryResult<T> {
  final bool success;
  final T? data;
  final String? error;
  final String? message;

  RepositoryResult({
    required this.success,
    this.data,
    this.error,
    this.message,
  });

  factory RepositoryResult.success(T data, {String? message}) {
    return RepositoryResult(
      success: true,
      data: data,
      message: message ?? 'Operation successful',
    );
  }

  factory RepositoryResult.failure(String error) {
    return RepositoryResult(
      success: false,
      error: error,
    );
  }
}
