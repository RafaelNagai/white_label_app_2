class InitialSetupModel {
  final List<String> featureFlags;

  InitialSetupModel({required this.featureFlags});

  factory InitialSetupModel.mock() {
    return InitialSetupModel(featureFlags: ["test_01", "test_02"]);
  }
}
