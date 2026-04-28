import 'dart:convert';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/Login_model_response.dart';
import '../../models/explore_model_response.dart';
import '../../models/make_song_response.dart';

part 'login_event.dart';
part 'login_repository.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginRepository adminKeyLoginRepository = LoginRepository();

  LoginBloc() : super(LoginInitialState()) {
    on<LoginInitialEvent>((event, emit) => emit(LoginInitialState()));
    on<LoginDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(LoginDataEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      await adminKeyLoginRepository.login(event.login);
      if (adminKeyLoginRepository.success == true) {
        emit(LoginSuccessState(
            login: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(LoginFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(LoginExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }

}
