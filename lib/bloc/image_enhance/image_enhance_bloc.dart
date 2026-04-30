import 'dart:convert';
import 'package:ai_interior/models/common_model_response.dart';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/explore_model_response.dart';

part 'image_enhance_event.dart';
part 'image_enhance_repository.dart';
part 'image_enhance_state.dart';

class ImageEnhanceBloc extends Bloc<ImageEnhanceEvent, ImageEnhanceState> {
  ImageEnhanceRepository adminKeyImageEnhanceRepository = ImageEnhanceRepository();

  ImageEnhanceBloc() : super(ImageEnhanceInitialState()) {
    on<ImageEnhanceInitialEvent>((event, emit) => emit(ImageEnhanceInitialState()));
    on<ImageEnhanceDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(ImageEnhanceDataEvent event, Emitter<ImageEnhanceState> emit) async {
    emit(ImageEnhanceLoadingState());
    try {
      await adminKeyImageEnhanceRepository.login(event.login);
      if (adminKeyImageEnhanceRepository.success == true) {
        emit(ImageEnhanceSuccessState(
            login: adminKeyImageEnhanceRepository.makeSongResponse,
            message: adminKeyImageEnhanceRepository.message.toString().trim(),
        )
        );
      } else {
        emit(ImageEnhanceFailureState(
          message: adminKeyImageEnhanceRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(ImageEnhanceExceptionState(
        message: adminKeyImageEnhanceRepository.message.toString().trim(),
      ));
    }
  }

}
