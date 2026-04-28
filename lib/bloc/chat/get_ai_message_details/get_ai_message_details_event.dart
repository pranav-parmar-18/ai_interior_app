part of 'get_ai_message_details_bloc.dart';

abstract class GetAIMessageDetailsEvent extends Equatable {
  const GetAIMessageDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetAIMessageDetailsInitialEvent extends GetAIMessageDetailsEvent {}

class GetAIMessageDetailsDataEvent extends GetAIMessageDetailsEvent {

final String id;
  const GetAIMessageDetailsDataEvent({required this.id});
}
