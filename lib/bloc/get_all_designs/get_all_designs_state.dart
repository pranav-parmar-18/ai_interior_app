part of 'get_all_designs_bloc.dart';

abstract class GetAllInteriorDesignState extends Equatable {
  GetAllInteriorDesignState();

  @override
  List<Object> get props => [];
}

class GetAllInteriorDesignInitialState extends GetAllInteriorDesignState {}

class GetAllInteriorDesignLoadingState extends GetAllInteriorDesignState {
  GetAllInteriorDesignLoadingState();
}

class GetAllInteriorDesignSuccessState extends GetAllInteriorDesignState {
  final GetAllInteriorDesignModelResponse? exploreSongResponse;
  final String message;

  GetAllInteriorDesignSuccessState({
    required this.exploreSongResponse,
    required this.message,
  });
}

class GetAllInteriorDesignFailureState extends GetAllInteriorDesignState {
  final String message;

  GetAllInteriorDesignFailureState({
    required this.message,
  });
}

class GetAllInteriorDesignExceptionState extends GetAllInteriorDesignState {
  final String message;

  GetAllInteriorDesignExceptionState({
    required this.message,
  });
}
