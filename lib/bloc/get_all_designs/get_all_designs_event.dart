part of 'get_all_designs_bloc.dart';

abstract class GetGiftListEvent extends Equatable {
  const GetGiftListEvent();

  @override
  List<Object> get props => [];
}

class GetGiftListInitialEvent extends GetGiftListEvent {}

class GetGiftListDataEvent extends GetGiftListEvent {


  const GetGiftListDataEvent();
}
