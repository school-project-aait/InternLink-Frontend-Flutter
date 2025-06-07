sealed class Resource<T> {
  const Resource();

  // Add this method to enable pattern matching
  Object? when<R>({
    required R Function(T data) success,
    required R Function(String message, Object? error) error,
    required R Function() loading,
  }) {
    return switch (this) {
      ResourceSuccess<T>(:final data) => success(data),
      ResourceError<T>(:final message, :final error) => error!,
      ResourceLoading<T>() => loading(),
    };
  }
}

class ResourceSuccess<T> extends Resource<T> {
  final T data;
  const ResourceSuccess(this.data);
}

class ResourceError<T> extends Resource<T> {
  final String message;
  final Object? error;
  const ResourceError(this.message, [this.error]);
}

class ResourceLoading<T> extends Resource<T> {
  const ResourceLoading();
}