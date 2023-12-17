import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myclasses/src/utils/states/cubit_state.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<CubitState> {
  LoginCubit() : super(CubitState.initial());

  Future<void> emailSignIn({
    required String email,
    required String password,
  }) async {
    emit(CubitState.show(data: 'id'));
  }
}
