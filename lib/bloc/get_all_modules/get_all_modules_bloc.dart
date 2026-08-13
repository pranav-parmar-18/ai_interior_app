import 'dart:convert';
import 'package:ai_interior/models/app_module_model.dart';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'get_all_modules_event.dart';
part 'get_all_modules_repository.dart';
part 'get_all_modules_state.dart';

class GetAllModulesBloc extends Bloc<GetAllModulesEvent, GetAllModulesState> {
  GetAllModulesRepository adminKeyLoginRepository = GetAllModulesRepository();

  GetAllModulesBloc() : super(GetAllModulesSuccessState(modules: AppModule.defaultModules, message: "Success")) {
    on<GetAllModulesInitialEvent>((event, emit) => emit(GetAllModulesSuccessState(modules: adminKeyLoginRepository.modulesList ?? AppModule.defaultModules, message: "Success")));
    on<GetAllModulesDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(GetAllModulesDataEvent event, Emitter<GetAllModulesState> emit) async {
    // Immediately emit local static modules for zero latency
    emit(GetAllModulesSuccessState(
      modules: adminKeyLoginRepository.modulesList ?? AppModule.defaultModules,
      message: "Success",
    ));

    try {
      await adminKeyLoginRepository.GetAllModules();
      emit(GetAllModulesSuccessState(
        modules: adminKeyLoginRepository.modulesList ?? AppModule.defaultModules,
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    } catch (error) {
      if (kDebugMode) {
        print("GetAllModulesBloc exception: $error");
      }
      emit(GetAllModulesSuccessState(
        modules: adminKeyLoginRepository.modulesList ?? AppModule.defaultModules,
        message: "Success",
      ));
    }
  }
}
