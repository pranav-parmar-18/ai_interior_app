part of 'get_enhancment_response_api_bloc.dart';

abstract class GetDesignByIDEvent extends Equatable {
  const GetDesignByIDEvent();

  @override
  List<Object> get props => [];
}

class GetDesignByIDInitialEvent extends GetDesignByIDEvent {}

class GetDesignByIDDataEvent extends GetDesignByIDEvent {


  const GetDesignByIDDataEvent();
}
