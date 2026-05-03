import 'dart:convert';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/get_all_exterior_design_model_response.dart';
import '../../models/get_all_interrior_design_model_response.dart';

part 'get_all_exterior_designs_event.dart';

part 'get_all_exterior_designs_repository.dart';

part 'get_all_exterior_designs_state.dart';

class GetAllExteriorDesignBloc
    extends Bloc<GetAllExteriorDesignEvent, GetAllExteriorDesignState> {
  GetAllExteriorDesignRepository adminKeyLoginRepository =
      GetAllExteriorDesignRepository();

  GetAllExteriorDesignBloc() : super(GetAllExteriorDesignInitialState()) {
    on<GetAllExteriorDesignInitialEvent>(
      (event, emit) => emit(GetAllExteriorDesignInitialState()),
    );
    on<GetAllExteriorDesignDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(
    GetAllExteriorDesignDataEvent event,
    Emitter<GetAllExteriorDesignState> emit,
  ) async {
    emit(GetAllExteriorDesignLoadingState());
    try {
      await adminKeyLoginRepository.getAllInteriorDesign(event.data);
      if (adminKeyLoginRepository.success == true) {
        emit(
          GetAllExteriorDesignSuccessState(
            exploreSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
          ),
        );
      } else {
        emit(
          GetAllExteriorDesignFailureState(
            message: adminKeyLoginRepository.message.toString().trim(),
          ),
        );
      }
    } catch (error) {
      print(error);
      emit(
        GetAllExteriorDesignExceptionState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ),
      );
    }
  }
}
