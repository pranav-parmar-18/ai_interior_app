part of 'recent_list_bloc.dart';

abstract class PartnerListState extends Equatable {
  PartnerListState();

  @override
  List<Object> get props => [];
}

class PartnerListInitialState extends PartnerListState {}

class PartnerListLoadingState extends PartnerListState {
  PartnerListLoadingState();
}

class PartnerListSuccessState extends PartnerListState {
  final PartnerListResponse? exploreSongResponse;
  final String message;

  PartnerListSuccessState({
    required this.exploreSongResponse,
    required this.message,
  });
}

class PartnerListFailureState extends PartnerListState {
  final String message;

  PartnerListFailureState({
    required this.message,
  });
}

class PartnerListExceptionState extends PartnerListState {
  final String message;

  PartnerListExceptionState({
    required this.message,
  });
}
