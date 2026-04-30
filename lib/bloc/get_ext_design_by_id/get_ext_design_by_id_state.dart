part of 'get_ext_design_by_id_bloc.dart';

abstract class GetDesignByIDState extends Equatable {
  GetDesignByIDState();

  @override
  List<Object> get props => [];
}

class GetDesignByIDInitialState extends GetDesignByIDState {}

class GetDesignByIDLoadingState extends GetDesignByIDState {
  GetDesignByIDLoadingState();
}

class GetDesignByIDSuccessState extends GetDesignByIDState {
  final CommonModelResponse? exploreSongResponse;
  final String message;

  GetDesignByIDSuccessState({
    required this.exploreSongResponse,
    required this.message,
  });
}

class GetDesignByIDFailureState extends GetDesignByIDState {
  final String message;

  GetDesignByIDFailureState({
    required this.message,
  });
}

class GetDesignByIDExceptionState extends GetDesignByIDState {
  final String message;

  GetDesignByIDExceptionState({
    required this.message,
  });
}
