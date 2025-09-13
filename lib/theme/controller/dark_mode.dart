import 'package:flutter_riverpod/flutter_riverpod.dart';
/// StateNotifier to control dark mode
class ThemeController extends StateNotifier<bool> {
  ThemeController() : super(false); // default is light mode (false)
  /// Toggle between light and dark mode
  void toggleTheme() {
    state = !state;
  }
  /// Explicit setters
  void setDarkMode() => state = true;
  void setLightMode() => state = false;
}
/// Provider for theme controller
final themeControllerProvider =
StateNotifierProvider<ThemeController, bool>((ref) {
  return ThemeController();
});