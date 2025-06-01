import SwiftUI
extension View {
  /// Adds a notifier for safe area insets that the toast system can use for proper positioning.
  ///
  /// This is an internal helper method used by the toast system.
  public func addToastSafeAreaObserver() -> some View {
    self._background {
      GeometryReader { geometry in
        Color.clear
          .preference(key: SafeAreaInsetsPreferenceKey.self, value: geometry.safeAreaInsets)
      }
    }
  }
}

enum SafeAreaInsetsPreferenceKey: PreferenceKey {
  static let defaultValue: EdgeInsets = .init()
  static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {
    let next = nextValue()
    value = EdgeInsets(
      top: max(value.top, next.top),
      leading: max(value.leading, next.leading),
      bottom: max(value.bottom, next.bottom),
      trailing: max(value.trailing, next.trailing))
  }
}
