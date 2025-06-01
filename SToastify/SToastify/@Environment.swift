import SwiftUI
// @Environment(\.windowScene) private var windowScene
#if os(iOS) || os(tvOS) || os(visionOS)
@available(iOS 13.0, *)
public class PassthroughWindow: UIWindow {
    /// Previously, before iOS 18, this code was enough to make sure to create
    /// a passthrough view/window, but from iOs 18, this code won't have interactions
    /// on the passthrough window views. Let me show you a demo of it, and then let's see how we can fix it.
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event), let rootView = rootViewController?.view else {
            return nil
        }

        if #available(iOS 18, *) {
            for subview in rootView.subviews.reversed() {
                /// Finding if any of rootview's subview is receiving hit test.
                let pointInSubView = subview.convert(point, from: rootView)
                if subview.hitTest(pointInSubView, with: event) != nil {
                    return hitView
                }
            }
            return nil
        } else {
            return hitView == rootView ? nil : hitView
        }
    }
}

private struct WindowKey: EnvironmentKey {
    static var defaultValue: UIWindow? {
        nil
    }
}

private struct WindowLevelKey: EnvironmentKey {
    static var defaultValue: UIWindow.Level {
        .normal
    }
}

@available(iOS 13.0, *)
public extension UIWindowScene {
    static var `defaultValue`: UIWindowScene? {
        MainActor.runSync {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first
        }
    }
}

@available(iOS 13.0, *)
public extension UIWindow {
    static var `defaultValue`: UIWindow? {
        MainActor.runSync {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        }
    }
}

@available(iOS 13.0, tvOS 13.0, visionOS 1.0, *)
public struct WindowSceneKey: EnvironmentKey {
    public static var defaultValue: UIWindowScene? {
        MainActor.runSync {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first
        }
    }
}

@available(iOS 13.0, tvOS 13.0, visionOS 1.0, *)
public extension EnvironmentValues {
    /// The window scene of this environment.
    ///
    /// Read this environment value from within a view to find the window scene
    /// for this presentation. If no `UIWindowScene` was set then it will default
    /// to the first connected `UIWindowScene`
    var windowScene: UIWindowScene? {
        get { self[WindowSceneKey.self] }
        set { self[WindowSceneKey.self] = newValue }
    }
    
    var window: UIWindow? {
        get { self[WindowKey.self] }
        set { self[WindowKey.self] = newValue }
    }
}

@available(iOS 13.0, *)
extension MainActor {
    #if swift(<5.10)
    @_unavailableFromAsync
    private static func runUnsafely<T>(_ body: @MainActor () throws -> T) rethrows -> T {
        if #available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *) {
            return try MainActor.assumeIsolated(body)
        } else {
            dispatchPrecondition(condition: .onQueue(.main))
            return try withoutActuallyEscaping(body) { function in
                try unsafeBitCast(function, to: (() throws -> T).self)()
            }
        }
    }
    #endif
    
    /// Execute the given body closure on the main actor without enforcing MainActor isolation.
    ///
    /// The method will be dispatched in sync to the main-thread if its on a non-main thread.
    @_unavailableFromAsync
    static func runSync<T>(_ body: @MainActor () throws -> T) rethrows -> T where T: Sendable {
        if Thread.isMainThread {
            #if swift(>=5.10)
            try MainActor.assumeIsolated(body)
            #else
            try MainActor.runUnsafely(body)
            #endif
        } else {
            try DispatchQueue.main.sync {
                #if swift(>=5.10)
                try MainActor.assumeIsolated(body)
                #else
                try MainActor.runUnsafely(body)
                #endif
            }
        }
    }
}
#endif
