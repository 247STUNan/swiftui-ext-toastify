import SwiftUI
// ========== ========== ========== ========== ========== ==========
struct HudProgressView: View {
    var body: some View {
        VStack(content: {
            ProgressView()
                .controlSize(.large)
                .padding(32)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 6))
                
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.black.opacity(0.08)
                .background(.ultraThinMaterial.opacity(0.94))
                .blur(radius: 4, opaque: false)
        )
    }
}
