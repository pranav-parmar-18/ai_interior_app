import 'dart:convert';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/category_model_response.dart';
import '../../models/explore_model_response.dart';
import '../../models/make_song_response.dart';



part 'logout_event.dart';
part 'logout_repository.dart';
part 'logout_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryRepository adminKeyLoginRepository = CategoryRepository();

  CategoryBloc() : super(CategoryInitialState()) {
    on<CategoryInitialEvent>((event, emit) => emit(CategoryInitialState()));
    on<CategoryDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(CategoryDataEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoadingState());
    try {
      await adminKeyLoginRepository.explore(event.makeSongData);
      if (adminKeyLoginRepository.success == true) {
        emit(CategorySuccessState(
            categoryModalResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(CategoryFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(CategoryExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
