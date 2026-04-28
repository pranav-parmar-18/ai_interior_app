part of 'get_photos_list_bloc.dart';

abstract class GetAllModulesEvent extends Equatable {
  const GetAllModulesEvent();

  @override
  List<Object> get props => [];
}

class GetAllModulesInitialEvent extends GetAllModulesEvent {}

class GetAllModulesDataEvent extends GetAllModulesEvent {


  const GetAllModulesDataEvent();
}
