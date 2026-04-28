import 'dart:convert';
  import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/common_model_response.dart';
import '../../models/make_song_response.dart';



part 'delete_account_event.dart';
part 'delete_account_repository.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  DeleteAccountRepository adminKeyLoginRepository = DeleteAccountRepository();

  DeleteAccountBloc() : super(DeleteAccountInitialState()) {
    on<KeyLoginInitialEvent>((event, emit) => emit(DeleteAccountInitialState()));
    on<DeleteAccountDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(DeleteAccountDataEvent event, Emitter<DeleteAccountState> emit) async {
    emit(DeleteAccountLoadingState());
    try {
      await adminKeyLoginRepository.deleteVideo();
      if (adminKeyLoginRepository.success == true) {
        emit(DeleteAccountSuccessState(
            makeSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(DeleteAccountFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(DeleteAccountExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
