part of 'get_all_style_transfer_design_bloc.dart';

abstract class GetDesignByIDEvent extends Equatable {
  const GetDesignByIDEvent();

  @override
  List<Object> get props => [];
}

class GetDesignByIDInitialEvent extends GetDesignByIDEvent {}

class GetDesignByIDDataEvent extends GetDesignByIDEvent {


  const GetDesignByIDDataEvent();
}
