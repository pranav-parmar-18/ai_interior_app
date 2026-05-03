import 'dart:convert';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/get_all_interrior_design_model_response.dart';

part 'get_all_designs_event.dart';

part 'get_all_designs_repository.dart';

part 'get_all_designs_state.dart';

class GetAllInteriorDesignBloc
    extends Bloc<GetAllInteriorDesignEvent, GetAllInteriorDesignState> {
  GetAllInteriorDesignRepository adminKeyLoginRepository =
      GetAllInteriorDesignRepository();

  GetAllInteriorDesignBloc() : super(GetAllInteriorDesignInitialState()) {
    on<GetAllInteriorDesignInitialEvent>(
      (event, emit) => emit(GetAllInteriorDesignInitialState()),
    );
    on<GetAllInteriorDesignDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(
    GetAllInteriorDesignDataEvent event,
    Emitter<GetAllInteriorDesignState> emit,
  ) async {
    emit(GetAllInteriorDesignLoadingState());
    try {
      await adminKeyLoginRepository.getAllInteriorDesign(event.data);
      if (adminKeyLoginRepository.success == true) {
        emit(
          GetAllInteriorDesignSuccessState(
            exploreSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
          ),
        );
      } else {
        emit(
          GetAllInteriorDesignFailureState(
            message: adminKeyLoginRepository.message.toString().trim(),
          ),
        );
      }
    } catch (error) {
      print(error);
      emit(
        GetAllInteriorDesignExceptionState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ),
      );
    }
  }
}
