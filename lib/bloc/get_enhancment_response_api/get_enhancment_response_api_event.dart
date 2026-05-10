part of 'get_enhancment_response_api_bloc.dart';

abstract class GerEnhancmentResponseEvent extends Equatable {
  const GerEnhancmentResponseEvent();

  @override
  List<Object> get props => [];
}

class GerEnhancmentResponseInitialEvent extends GerEnhancmentResponseEvent {}

class GerEnhancmentResponseDataEvent extends GerEnhancmentResponseEvent {
  final Map<String, dynamic> data;

  const GerEnhancmentResponseDataEvent({required this.data});
}
