import 'package:equatable/equatable.dart';

import '../../models/music_model.dart';


abstract class MusicState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MusicInitial extends MusicState {}

class MusicLoading extends MusicState {}

class MusicLoaded extends MusicState {
  final List<Music> musicList;
  MusicLoaded(this.musicList);

  @override
  List<Object?> get props => [musicList];
}

class MusicError extends MusicState {
  final String message;
  MusicError(this.message);

  @override
  List<Object?> get props => [message];
}
