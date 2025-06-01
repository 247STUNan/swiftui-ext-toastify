import SwiftUI

@MainActor
internal final class ToastManager: ObservableObject {
    @Published internal var position: ToastPosition = .top
    @Published internal private(set) var models: [ToastifyModels] = []
    @Published internal private(set) var isAppeared = false
    @Published internal var safeAreaInsets: EdgeInsets = .init()
    private var dismissOverlayTask: Task<Void, any Error>?
    internal func onAppear() { isAppeared = true }
    
    internal func append(_ toast: ToastValue) {
        dismissOverlayTask?.cancel()
        dismissOverlayTask = nil
        let model = ToastifyModels(value: toast)
        models.append(model)
    }
    
    func remove(_ model: ToastifyModels) {
        if let index = self.models.firstIndex(where: { $0 === model }) {
            self.models.remove(at: index)
        }
        if models.isEmpty {
            dismissOverlayTask = Task {
                try await Task.sleep(seconds: removalAnimationDuration)
                isAppeared = false
            }
        }
    }
    
    internal func startRemovalTask(for model: ToastifyModels) async {
      if let duration = model.value.duration {
        do {
          try await Task.sleep(seconds: duration)
          remove(model)
        } catch {}
      }
    }
}
