part of 'get_style_transfer_based_on_userid_bloc.dart';

abstract class GetGiftListEvent extends Equatable {
  const GetGiftListEvent();

  @override
  List<Object> get props => [];
}

class GetGiftListInitialEvent extends GetGiftListEvent {}

class GetGiftListDataEvent extends GetGiftListEvent {


  const GetGiftListDataEvent();
}
