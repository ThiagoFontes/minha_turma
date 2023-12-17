enum CubitStatus { initial, loading, show }

class CubitState<T, W> {
  final T? data;
  final W? error;

  final CubitStatus status;

  CubitState.initial({this.data})
      : status = CubitStatus.initial,
        error = null;

  CubitState.loading({this.data})
      : status = CubitStatus.loading,
        error = null;

  CubitState.show({this.data, this.error}) : status = CubitStatus.show;

  bool get isSuccess => (data != null) && (error == null);
  bool get isError => !isSuccess;
}
