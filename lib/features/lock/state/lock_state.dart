class LockState {
  const LockState({
    required this.biometricEnabled,
    required this.pinEnabled,
    required this.locked,
    this.biometricsAvailable = false,
    this.showPin = false,
  });

  final bool biometricEnabled; // user pref (biometrics)
  final bool pinEnabled; // user pref (PIN)
  final bool locked; // overlay visible
  final bool biometricsAvailable; // device capability
  final bool showPin; // whether overlay renders PIN UI now

  LockState copyWith({
    bool? biometricEnabled,
    bool? pinEnabled,
    bool? locked,
    bool? biometricsAvailable,
    bool? showPin,
  }) {
    return LockState(
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      pinEnabled: pinEnabled ?? this.pinEnabled,
      locked: locked ?? this.locked,
      biometricsAvailable: biometricsAvailable ?? this.biometricsAvailable,
      showPin: showPin ?? this.showPin,
    );
  }
}
