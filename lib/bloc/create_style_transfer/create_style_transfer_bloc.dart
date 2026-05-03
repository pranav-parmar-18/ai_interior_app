import 'dart:convert';
import 'dart:io';
import 'package:ai_interior/models/common_model_response.dart';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/create_style_transfer_model_response.dart';
import '../../models/explore_model_response.dart';

part 'create_style_transfer_event.dart';
part 'create_style_transfer_repository.dart';
part 'create_style_transfer_state.dart';

class CreateStyleTransferBloc extends Bloc<CreateStyleTransferEvent, CreateStyleTransferState> {
  CreateStyleTransferRepository adminKeyCreateStyleTransferRepository = CreateStyleTransferRepository();

  CreateStyleTransferBloc() : super(CreateStyleTransferInitialState()) {
    on<CreateStyleTransferInitialEvent>((event, emit) => emit(CreateStyleTransferInitialState()));
    on<CreateStyleTransferDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(CreateStyleTransferDataEvent event, Emitter<CreateStyleTransferState> emit) async {
    emit(CreateStyleTransferLoadingState());
    try {
      await adminKeyCreateStyleTransferRepository.createStyleTransfer(event.login,event.image,event.refImage);
      if (adminKeyCreateStyleTransferRepository.success == true) {
        emit(CreateStyleTransferSuccessState(
            login: adminKeyCreateStyleTransferRepository.makeSongResponse,
            message: adminKeyCreateStyleTransferRepository.message.toString().trim(),
        )
        );
      } else {
        emit(CreateStyleTransferFailureState(
          message: adminKeyCreateStyleTransferRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(CreateStyleTransferExceptionState(
        message: adminKeyCreateStyleTransferRepository.message.toString().trim(),
      ));
    }
  }

}
