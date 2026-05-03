part of 'get_all_exterior_designs_bloc.dart';

abstract class GetAllExteriorDesignState extends Equatable {
  GetAllExteriorDesignState();

  @override
  List<Object> get props => [];
}

class GetAllExteriorDesignInitialState extends GetAllExteriorDesignState {}

class GetAllExteriorDesignLoadingState extends GetAllExteriorDesignState {
  GetAllExteriorDesignLoadingState();
}

class GetAllExteriorDesignSuccessState extends GetAllExteriorDesignState {
  final GetAllExteriorDesignModelResponse? exploreSongResponse;
  final String message;

  GetAllExteriorDesignSuccessState({
    required this.exploreSongResponse,
    required this.message,
  });
}

class GetAllExteriorDesignFailureState extends GetAllExteriorDesignState {
  final String message;

  GetAllExteriorDesignFailureState({
    required this.message,
  });
}

class GetAllExteriorDesignExceptionState extends GetAllExteriorDesignState {
  final String message;

  GetAllExteriorDesignExceptionState({
    required this.message,
  });
}
