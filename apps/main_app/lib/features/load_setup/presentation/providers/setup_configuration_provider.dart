import 'package:main_app/features/load_setup/data/datasources/initial_setup_datasource.dart';
import 'package:main_app/features/load_setup/data/repositories/setup_repository.dart';
import 'package:main_app/features/load_setup/domain/entities/setup_configuration.dart';
import 'package:main_app/features/load_setup/domain/repositories/setup_repository.dart';
import 'package:main_app/features/load_setup/domain/usecases/get_setup_configuration_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'setup_configuration_provider.g.dart';

@riverpod
InitialSetupDatasource initialSetupDatasource(Ref ref) {
  return InitialSetupDatasource();
}

@riverpod
SetupRepository setupRepository(Ref ref) {
  return SetupRepositoryImpl(
    themeDatasource: ref.watch(initialSetupDatasourceProvider),
  );
}

@riverpod
GetSetupConfigurationUsecase getSetupConfigurationUsecase(Ref ref) {
  return GetSetupConfigurationUsecase(
    repository: ref.watch(setupRepositoryProvider),
  );
}

@riverpod
Future<SetUpConfiguration> loadSetupConfiguration(Ref ref) async {
  final usecase = ref.watch(getSetupConfigurationUsecaseProvider);
  final result = await usecase();

  return result.fold(
    (failure) => throw failure,
    (themeConfiguration) => themeConfiguration,
  );
}
