part of 'get_ai_message_list_bloc.dart';

abstract class GetAIMessageListEvent extends Equatable {
  const GetAIMessageListEvent();

  @override
  List<Object> get props => [];
}

class GetAIMessageListInitialEvent extends GetAIMessageListEvent {}

class GetAIMessageListDataEvent extends GetAIMessageListEvent {


  const GetAIMessageListDataEvent();
}
