import SwiftUI
internal let removalAnimationDuration: Double = 0.3
internal struct ToastifyRootView: View {
    var body: some View { main }
    @StateObject private var manager = ToastManager()
    @ViewBuilder
    private var main: some View {
        let isTop = manager.position == .top
        let models = isTop ? manager.models.reversed() : manager.models
        VStack(spacing: 8) {
            if !isTop { Spacer() }
            ForEach(manager.isAppeared ? models : []) { model in
                ToastInteractingView(model: model, manager: manager)
                    .transition(
                        .modifier(
                            active: TransformModifier(
                                yOffset: isTop ? -96 : 96,
                                scale: 0.5,
                                opacity: 0.0
                            ),
                            identity: TransformModifier(
                                yOffset: 0,
                                scale: 1.0,
                                opacity: 1.0
                            )
                        )
                    )
            }
            if isTop { Spacer() }
        }
        .animation(.spring(duration: removalAnimationDuration), value: Tuple(count: manager.models.count, isAppeared: manager.isAppeared))
        .padding()
        .padding(manager.safeAreaInsets)
        .padding(manager.isAppeared ? ViewConst.safeAreaInsets : .init())
        .animation(.spring(duration: removalAnimationDuration), value: manager.safeAreaInsets)
        .ignoresSafeArea()
        .addToastSafeAreaObserver()
        .onReceive(EMethodsToastify.pubReceive) { value in
            switch value {
            case .append(let toastValue):
                self.manager.append(toastValue)
                self.manager.onAppear()
            case .position(position: let position):
                self.manager.position = position
            }
        }
    }
}

struct Tuple: Equatable {
    var count: Int
    var isAppeared: Bool
}
