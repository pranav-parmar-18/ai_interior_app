part of 'get_all_designs_bloc.dart';

abstract class GetGiftListState extends Equatable {
  GetGiftListState();

  @override
  List<Object> get props => [];
}

class GetGiftListInitialState extends GetGiftListState {}

class GetGiftListLoadingState extends GetGiftListState {
  GetGiftListLoadingState();
}

class GetGiftListSuccessState extends GetGiftListState {
  final GetGiftListResponse? exploreSongResponse;
  final String message;

  GetGiftListSuccessState({
    required this.exploreSongResponse,
    required this.message,
  });
}

class GetGiftListFailureState extends GetGiftListState {
  final String message;

  GetGiftListFailureState({
    required this.message,
  });
}

class GetGiftListExceptionState extends GetGiftListState {
  final String message;

  GetGiftListExceptionState({
    required this.message,
  });
}
