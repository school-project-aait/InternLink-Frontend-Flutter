sealed class Resource<T> {
  const Resource();

  /// Pattern matching utility for handling success, error, and loading states.
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Object? error) error,
    required R Function() loading,
  }) {
    if (this is ResourceSuccess<T>) {
      return success((this as ResourceSuccess<T>).data);
    } else if (this is ResourceError<T>) {
      final err = this as ResourceError<T>;
      return error(err.message, err.error);
    } else if (this is ResourceLoading<T>) {
      return loading();
    } else {
      throw Exception('Unhandled Resource type: $this');
    }
  }
}

final class ResourceSuccess<T> extends Resource<T> {
  final T data;
  const ResourceSuccess(this.data);
}

final class ResourceError<T> extends Resource<T> {
  final String message;
  final Object? error;
  const ResourceError(this.message, [this.error]);
}

final class ResourceLoading<T> extends Resource<T> {
  const ResourceLoading();
}
