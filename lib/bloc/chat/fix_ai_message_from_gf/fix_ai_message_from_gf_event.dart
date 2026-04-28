part of 'fix_ai_message_from_gf_bloc.dart';

abstract class FixAIMessageFromGFEvent extends Equatable {
  const FixAIMessageFromGFEvent();

  @override
  List<Object> get props => [];
}

class FixAIMessageFromGFInitialEvent extends FixAIMessageFromGFEvent {}

class FixAIMessageFromGFDataEvent extends FixAIMessageFromGFEvent {

}
