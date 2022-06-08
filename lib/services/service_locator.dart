import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:smarter/services/playlist_repository.dart';

import 'audio_handler.dart';

final getIt = GetIt.instance;

setupServiceLocator() async {
  getIt.registerSingleton<AudioHandler>(await initAudioService());
  getIt.registerSingleton<PlaylistRepository>(initRepository());
}
