import 'dart:convert';
import 'package:ai_interior/models/common_model_response.dart';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/create_user_model_response.dart';

part 'create_user_event.dart';
part 'create_user_repository.dart';
part 'create_user_state.dart';

class CreateUserBloc extends Bloc<CreateUserEvent, CreateUserState> {
  CreateUserRepository adminKeyCreateUserRepository = CreateUserRepository();

  CreateUserBloc() : super(CreateUserInitialState()) {
    on<CreateUserInitialEvent>((event, emit) => emit(CreateUserInitialState()));
    on<CreateUserDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(CreateUserDataEvent event, Emitter<CreateUserState> emit) async {
    emit(CreateUserLoadingState());
    try {
      await adminKeyCreateUserRepository.login(event.login);
      if (adminKeyCreateUserRepository.success == true) {
        emit(CreateUserSuccessState(
            login: adminKeyCreateUserRepository.makeSongResponse,
            message: adminKeyCreateUserRepository.message.toString().trim(),
        )
        );
      } else {
        emit(CreateUserFailureState(
          message: adminKeyCreateUserRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(CreateUserExceptionState(
        message: adminKeyCreateUserRepository.message.toString().trim(),
      ));
    }
  }

}
