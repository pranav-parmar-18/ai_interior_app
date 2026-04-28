import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/music_model.dart';
import '../../services/database_services.dart';
import 'music_event.dart';
import 'music_state.dart';


class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance; // Singleton
  List<Music> _musicList = []; // Internal state

  MusicBloc() : super(MusicInitial()) {
    on<LoadMusic>(_onLoadMusic);
    on<AddMusic>(_onAddMusic);
    on<UpdateMusic>(_onUpdateMusic);
    on<DeleteMusic>(_onDeleteMusic);
    on<ToggleFavorite>(_onToggleFavorite);

    add(LoadMusic()); // Auto-load data on creation
  }

  Future<void> _onLoadMusic(LoadMusic event, Emitter<MusicState> emit) async {
    emit(MusicLoading());
    try {
      _musicList = await _dbHelper.getAllMusic(); // Fetch from DB
      emit(MusicLoaded(_musicList));

    } catch (e) {
      emit(MusicError("Failed to load music"));
    }
  }



  Future<void> _onAddMusic(AddMusic event, Emitter<MusicState> emit) async {
    await _dbHelper.insertMusic(event.music);
    _musicList.add(event.music); // Update local list
    emit(MusicLoaded(List.from(_musicList),)); // Emit updated state
    add(LoadMusic());
  }

  Future<void> _onUpdateMusic(UpdateMusic event, Emitter<MusicState> emit) async {
    await _dbHelper.updateMusic(event.music);
    int index = _musicList.indexWhere((m) => m.id == event.music.id);
    if (index != -1) {
      _musicList[index] = event.music; // Update local state
    }
    emit(MusicLoaded(List.from(_musicList),)); // Emit new state
    add(LoadMusic());
  }

  Future<void> _onDeleteMusic(DeleteMusic event, Emitter<MusicState> emit) async {
    await _dbHelper.deleteMusic(event.id);
    _musicList.removeWhere((m) => m.id == event.id); // Remove from local list
    emit(MusicLoaded(List.from(_musicList),)); // Emit updated state
    add(LoadMusic());
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<MusicState> emit) async {
    if (_musicList.isEmpty) return;

    // Find the song by its ID
    final index = _musicList.indexWhere((song) => song.id == event.id);
    if (index == -1) return; // If not found, exit

    // Toggle isFavorite for that specific song
    _musicList[index].isFavorite = _musicList[index].isFavorite == 1 ? 0 : 1;

    // Update the database
    await _dbHelper.updateMusic(_musicList[index]);

    // Emit updated state with new list
    emit(MusicLoaded(List.from(_musicList),));
    add(LoadMusic());
  }
}
