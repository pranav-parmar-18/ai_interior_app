class SubscriptionScreenManager {
  static final SubscriptionScreenManager _instance = SubscriptionScreenManager._internal();
  factory SubscriptionScreenManager() => _instance;
  SubscriptionScreenManager._internal();

  int _currentIndex = 0;

  /// Total subscription screens you have
  final int totalScreens = 3;

  /// Get next subscription screen index
  int getNextIndex() {
    int index = _currentIndex;
    _currentIndex = (_currentIndex + 1) % totalScreens;
    return index;
  }
}
