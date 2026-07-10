import 'package:dartz/dartz.dart';
import 'package:main_app/core/failures/failure.dart';
import 'package:main_app/features/load_setup/data/datasources/initial_setup_datasource.dart';
import 'package:main_app/features/load_setup/domain/entities/setup_configuration.dart';
import 'package:main_app/features/load_setup/domain/repositories/setup_repository.dart';

class SetupRepositoryImpl implements SetupRepository {
  final InitialSetupDatasource themeDatasource;

  SetupRepositoryImpl({required this.themeDatasource});

  @override
  Future<Either<Failure, SetUpConfiguration>> getInitialSetup() async {
    final themeConfiguration = await themeDatasource.getTheme();
    return Right(
      SetUpConfiguration(featureFlags: themeConfiguration.featureFlags),
    );
  }
}
