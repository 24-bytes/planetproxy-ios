import SwiftUI

struct SidebarItemView: View {
    let item: SidebarMenuItem
    @ObservedObject var viewModel: SidebarViewModel
    let navigation: NavigationCoordinator
    @EnvironmentObject var authViewModel: AuthViewModel // ✅ Inject AuthViewModel

    var body: some View {
        Button(action: { viewModel.selectMenuItem(item.destination, navigation: navigation, authViewModel: authViewModel) }) {
            HStack {
                Image(systemName: item.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                
                Text(item.title)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
        }
    }
}
