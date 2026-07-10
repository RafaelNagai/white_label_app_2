import 'package:dartz/dartz.dart';
import 'package:main_app/core/failures/failure.dart';
import 'package:main_app/features/load_setup/domain/entities/setup_configuration.dart';

abstract class SetupRepository {
  Future<Either<Failure, SetUpConfiguration>> getInitialSetup();
}
