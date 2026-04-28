part of 'add_credits_bloc.dart';

abstract class AddCreditsEvent extends Equatable {
  const AddCreditsEvent();

  @override
  List<Object> get props => [];
}

class AddCreditsInitialEvent extends AddCreditsEvent {}

class AddCreditsDataEvent extends AddCreditsEvent {
  final Map<String, dynamic> purchaseData;

  const AddCreditsDataEvent({required this.purchaseData});
}
