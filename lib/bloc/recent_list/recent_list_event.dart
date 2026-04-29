part of 'recent_list_bloc.dart';

abstract class PartnerListEvent extends Equatable {
  const PartnerListEvent();

  @override
  List<Object> get props => [];
}

class PartnerListInitialEvent extends PartnerListEvent {}

class PartnerListDataEvent extends PartnerListEvent {

final String genderId;
  const PartnerListDataEvent({required this.genderId});
}
