import Foundation
import SwiftUICore
@MainActor
@dynamicMemberLookup
internal final class ToastifyModels: ObservableObject, Identifiable {
  @Published internal var value: ToastValue
  internal init(value: ToastValue) {
    self.value = value
  }

  internal subscript<V>(dynamicMember keyPath: WritableKeyPath<ToastValue, V>) -> V {
    get { value[keyPath: keyPath] }
    set { value[keyPath: keyPath] = newValue }
  }
}
/// Represents a toast notification with customizable content and behavior.
public struct ToastValue {
  internal var icon: AnyView?
  internal var message: String
  internal var button: ToastButton?
  /// If nil, the toast will persist and not disappear. Used when displaying a loading toast.
  internal var duration: TimeInterval?

  /// Creates a new toast with the specified content and behavior.
  ///
  /// - Parameters:
  ///   - icon: An optional view to display as an icon in the toast.
  ///   - message: The text content of the toast.
  ///   - button: An optional action button to display in the toast.
  ///   - duration: How long the toast should be displayed before automatically dismissing, in seconds. Clamped between 0 and 10 seconds. Default is 3.0.
  public init(
    icon: (any View)? = nil,
    message: String,
    button: ToastButton? = nil,
    duration: TimeInterval = 3.0
  ) {
    self.icon = icon.map { AnyView($0) }
    self.message = message
    self.button = button
    self.duration = min(max(0, duration), 10)
  }
  @_disfavoredOverload
  internal init(
    icon: (any View)? = nil,
    message: String,
    button: ToastButton? = nil,
    duration: TimeInterval? = nil
  ) {
    self.icon = icon.map { AnyView($0) }
    self.message = message
    self.button = button
    self.duration = duration
  }
}
/// Represents an action button that can be displayed within a toast.
public struct ToastButton {
  /// The text to display on the button.
  public var title: String

  /// The color of the button text.
  public var color: Color

  /// The action to perform when the button is tapped.
  public var action: () -> Void

  /// Creates a new toast button with the specified title, color, and action.
  ///
  /// - Parameters:
  ///   - title: The text to display on the button.
  ///   - color: The color of the button text. Default is `.primary`.
  ///   - action: The closure to execute when the button is tapped.
  public init(
    title: String,
    color: Color = .primary,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.color = color
    self.action = action
  }
}

public enum ToastPosition {
  /// Toast appears at the top of the screen.
  case top
  /// Toast appears at the bottom of the screen.
  case bottom
}

// ========== ========== ========== ========== ========== ==========
@MainActor
@dynamicMemberLookup
internal final class HudToastify: ObservableObject, Identifiable {
    @Published  internal var view: AnyView
    internal var duration: TimeInterval? = TimeInterval(5)
    internal init(view: some View) {
        self.view = AnyView(view)
    }
    
    internal subscript<V>(dynamicMember keyPath: WritableKeyPath<AnyView, V>) -> V {
        get { view[keyPath: keyPath] }
        set { view[keyPath: keyPath] = newValue }
    }
    
    enum Views {
        case hudProgressView

        @MainActor
        func builder() -> HudToastify {
            switch self { case .hudProgressView: HudToastify.init(view: HudProgressView()) }
        }
    }
}
