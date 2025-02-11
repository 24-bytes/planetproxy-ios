import SwiftUI

struct NavBar: View {
    @EnvironmentObject var sidebarViewModel: SidebarViewModel // ✅ Sidebar ViewModel

    var body: some View {
        HStack {
            // Sidebar Toggle Button
            Button(action: {
                withAnimation {
                    sidebarViewModel.isSidebarOpen.toggle() // ✅ Toggle sidebar
                }
            }) {
                Image(systemName: "square.grid.2x2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }

            Spacer()

            // App Title
            Text("Planet Proxy")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            Spacer()

            // Premium Logo with Badge
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color.purple.opacity(0.8)) // Background color for logo
                
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)

                // Small Star Badge
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundColor(.orange)
                    .overlay(
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 8, height: 8)
                            .foregroundColor(.white)
                    )
                    .offset(x: 10, y: 10)
            }
        }
        .padding(.horizontal)
    }
}
