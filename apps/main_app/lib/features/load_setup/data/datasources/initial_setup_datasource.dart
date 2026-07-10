import 'package:main_app/features/load_setup/data/models/initial_setup_model.dart';

class InitialSetupDatasource {
  Future<InitialSetupModel> getTheme() async {
    await Future.delayed(Duration(seconds: 2));

    return InitialSetupModel.mock();
  }
}
