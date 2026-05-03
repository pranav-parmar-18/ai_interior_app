part of 'get_all_designs_bloc.dart';

abstract class GetAllInteriorDesignEvent extends Equatable {
  const GetAllInteriorDesignEvent();

  @override
  List<Object> get props => [];
}

class GetAllInteriorDesignInitialEvent extends GetAllInteriorDesignEvent {}

class GetAllInteriorDesignDataEvent extends GetAllInteriorDesignEvent {

  final Map<String,dynamic> data;
  const GetAllInteriorDesignDataEvent({required this.data});
}
