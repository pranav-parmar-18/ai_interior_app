part of 'get_ext_design_by_id_bloc.dart';

abstract class GetDesignByIDEvent extends Equatable {
  const GetDesignByIDEvent();

  @override
  List<Object> get props => [];
}

class GetDesignByIDInitialEvent extends GetDesignByIDEvent {}

class GetDesignByIDDataEvent extends GetDesignByIDEvent {


  const GetDesignByIDDataEvent();
}
