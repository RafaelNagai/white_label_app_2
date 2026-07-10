import 'package:dartz/dartz.dart';
import 'package:main_app/core/failures/failure.dart';
import 'package:main_app/features/load_setup/domain/entities/setup_configuration.dart';
import 'package:main_app/features/load_setup/domain/repositories/setup_repository.dart';

class GetSetupConfigurationUsecase {
  final SetupRepository repository;

  GetSetupConfigurationUsecase({required this.repository});

  Future<Either<Failure, SetUpConfiguration>> call() async {
    return repository.getInitialSetup();
  }
}
