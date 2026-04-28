import 'dart:convert';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/add_credit_model_response.dart';
part 'add_credits_event.dart';
part 'add_credits_repository.dart';
part 'add_credits_state.dart';

class AddCreditsBloc extends Bloc<AddCreditsEvent, AddCreditsState> {
  AddCreditsRepository adminKeyLoginRepository = AddCreditsRepository();

  AddCreditsBloc() : super(AddCreditsInitialState()) {
    on<AddCreditsInitialEvent>((event, emit) => emit(AddCreditsInitialState()));
    on<AddCreditsDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(AddCreditsDataEvent event, Emitter<AddCreditsState> emit) async {
    emit(AddCreditsLoadingState());
    try {
      await adminKeyLoginRepository.addCredit(event.purchaseData);
      if (adminKeyLoginRepository.success == true) {
        emit(AddCreditsSuccessState(
            categoryModalResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(AddCreditsFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(AddCreditsExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
