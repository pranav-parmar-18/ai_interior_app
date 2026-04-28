import 'dart:convert';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/category_model_response.dart';
import '../../models/explore_model_response.dart';
import '../../models/image_generator_response.dart';
import '../../models/make_song_response.dart';



part 'image_generator_event.dart';
part 'image_generator_repository.dart';
part 'image_generator_state.dart';

class ImageGeneratorBloc extends Bloc<ImageGeneratorEvent, ImageGeneratorState> {
  ImageGeneratorRepository adminKeyLoginRepository = ImageGeneratorRepository();

  ImageGeneratorBloc() : super(ImageGeneratorInitialState()) {
    on<ImageGeneratorInitialEvent>((event, emit) => emit(ImageGeneratorInitialState()));
    on<ImageGeneratorDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(ImageGeneratorDataEvent event, Emitter<ImageGeneratorState> emit) async {
    emit(ImageGeneratorLoadingState());
    try {
      await adminKeyLoginRepository.imageGenerator(event.imageGenData);
      if (adminKeyLoginRepository.success == true) {
        emit(ImageGeneratorSuccessState(
            imgResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(ImageGeneratorFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(ImageGeneratorExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
