import 'package:equatable/equatable.dart';
import '../../models/music_model.dart';


abstract class MusicEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMusic extends MusicEvent {}


class AddMusic extends MusicEvent {
  final Music music;
  AddMusic(this.music);

  @override
  List<Object?> get props => [music];
}

class UpdateMusic extends MusicEvent {
  final Music music;
  UpdateMusic(this.music);

  @override
  List<Object?> get props => [music];
}

class DeleteMusic extends MusicEvent {
  final int id;
  DeleteMusic(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleFavorite extends MusicEvent {
  final int id;
  ToggleFavorite(this.id);

  @override
  List<Object?> get props => [id];
}
