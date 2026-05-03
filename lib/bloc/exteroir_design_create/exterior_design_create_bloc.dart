import 'dart:convert';
import 'dart:io';
import 'package:ai_interior/models/common_model_response.dart';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/exterior_design_create_model_response.dart';
part 'exterior_design_create_event.dart';
part 'exterior_design_create_repository.dart';
part 'exterior_design_create_state.dart';

class ExteriorDeignCreateBloc extends Bloc<ExteriorDeignCreateEvent, ExteriorDeignCreateState> {
  ExteriorDeignCreateRepository adminKeyExteriorDeignCreateRepository = ExteriorDeignCreateRepository();

  ExteriorDeignCreateBloc() : super(ExteriorDeignCreateInitialState()) {
    on<ExteriorDeignCreateInitialEvent>((event, emit) => emit(ExteriorDeignCreateInitialState()));
    on<ExteriorDeignCreateDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(ExteriorDeignCreateDataEvent event, Emitter<ExteriorDeignCreateState> emit) async {
    emit(ExteriorDeignCreateLoadingState());
    try {
      await adminKeyExteriorDeignCreateRepository.exteriorDesignCreate(event.login,event.image);
      if (adminKeyExteriorDeignCreateRepository.success == true) {
        emit(ExteriorDeignCreateSuccessState(
            login: adminKeyExteriorDeignCreateRepository.makeSongResponse,
            message: adminKeyExteriorDeignCreateRepository.message.toString().trim(),
        )
        );
      } else {
        emit(ExteriorDeignCreateFailureState(
          message: adminKeyExteriorDeignCreateRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(ExteriorDeignCreateExceptionState(
        message: adminKeyExteriorDeignCreateRepository.message.toString().trim(),
      ));
    }
  }

}
