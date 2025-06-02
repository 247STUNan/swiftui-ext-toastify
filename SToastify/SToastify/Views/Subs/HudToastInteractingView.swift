import SwiftUI
// ========== ========== ========== ========== ========== ==========
internal struct HudToastInteractingView<Content: View>: View {
    var rootview: Content
    @ObservedObject var model: HudToastify
    let manager: ToastManager
    @State private var dismissTask: Task<Void, any Error>?
    init(
        @ViewBuilder content: @escaping () -> Content,
        model: HudToastify,
        manager: ToastManager
    ) {
        self.rootview = content()
        self.model = model
        self.manager = manager
    }
    var body: some View { main }
    
    @MainActor
    private var main: some View { rootview.onAppear { startDismissTask() } }
    
    private func startDismissTask() {
      dismissTask?.cancel()
      dismissTask = Task {
        await manager.startHudRemovalTask(for: model)
      }
    }
}
