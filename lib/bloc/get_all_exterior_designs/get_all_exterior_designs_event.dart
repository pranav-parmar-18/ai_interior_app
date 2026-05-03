part of 'get_all_exterior_designs_bloc.dart';

abstract class GetAllExteriorDesignEvent extends Equatable {
  const GetAllExteriorDesignEvent();

  @override
  List<Object> get props => [];
}

class GetAllExteriorDesignInitialEvent extends GetAllExteriorDesignEvent {}

class GetAllExteriorDesignDataEvent extends GetAllExteriorDesignEvent {

  final Map<String,dynamic> data;
  const GetAllExteriorDesignDataEvent({required this.data});
}
