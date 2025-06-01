import SwiftUI
struct ZRootView<Content: View>: View {
    @Environment(\.windowScene) private var windowScene
    @Environment(\.window) private var window
    var rootview: Content
    init(@ViewBuilder content: @escaping () -> Content) { self.rootview = content() }
    @State fileprivate var sWindowScene: UIWindowScene? = .defaultValue
    @State fileprivate var sWindow: UIWindow? = .defaultValue
    var body: some View {
        rootview
            .environment(\.window, sWindow)
            .environment(\.windowScene, sWindowScene)
            .onAppear {
                let cacheWindowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene)
                if let cacheWindowScene, window == nil {
                    let cacheWindow = PassthroughWindow(windowScene: windowScene ?? cacheWindowScene)
                    cacheWindow.isHidden = false
                    cacheWindow.isUserInteractionEnabled = true
                    let rootViewController = UIHostingController( rootView: ToastifyRootView())
                    rootViewController.view.backgroundColor = .clear
                    cacheWindow.rootViewController = rootViewController
                    sWindow = cacheWindow
                    sWindowScene = cacheWindowScene
                }
            }
    }
}

