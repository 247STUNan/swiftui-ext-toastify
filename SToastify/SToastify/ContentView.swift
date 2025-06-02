import SwiftUI
#Preview { ContentView() }
struct ContentView: View {
    var body: some View {
        List {
            Button {
                EMethodsToastify
                    .notify(
                        value: .append(
                            .init(
                                icon: Color.red,
                                message: "Gave PreviewsInjection a chance to run and it returned, continuing with debug dylib",
                                button: .init(title: "🤬", action: { print("@give") }),
                                duration: TimeInterval(5)
                            )
                        )
                    )
            } label: {
                Text("notify")
            }
            
            Button {
                EMethodsToastify.notify(value: .position(position: .bottom))
                EMethodsToastify
                    .notify(
                        value: .append(
                            .init(
                                icon: Color.red,
                                message: "Gave PreviewsInjection a chance to run and it returned, continuing with debug dylib",
                                button: .init(title: "🤬", action: { print("@give") }),
                                duration: TimeInterval(5)
                            )
                        )
                    )
            } label: {
                Text("notify-bottom")
            }
            
            Button {
                EMethodsToastify.notify(value: .position(position: .top))
                EMethodsToastify
                    .notify(
                        value: .append(
                            .init(
                                icon: Color.red,
                                message: "Gave PreviewsInjection a chance to run and it returned, continuing with debug dylib",
                                button: .init(title: "🤬", action: { print("@give") }),
                                duration: TimeInterval(5)
                            )
                        )
                    )
            } label: {
                Text("notify-top")
            }
            
            Button {
                EMethodsToastify.notify(value: .hudCenter(HudToastify.Views.hudProgressView.builder()))
            } label: {
                Text("@click-center")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
