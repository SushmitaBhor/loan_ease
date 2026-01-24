import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Register core services later (Dio, Hive, etc.)

  // Example (to add later):
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  // sl.registerFactory<AuthBloc>(() => AuthBloc(sl()));
}
