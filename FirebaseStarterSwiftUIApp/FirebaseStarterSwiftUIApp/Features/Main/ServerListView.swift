import SwiftUI

struct ServerListView: View {
    @State private var searchText = ""
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            // Search bar
            SearchField(text: $searchText, placeholder: "Search servers")
            
            // Server tabs
            CustomSegmentedControl(selection: $selectedTab,
                                 items: ["Default", "Streaming", "Gaming"])
            
            // Server list
            ScrollView {
                // Server items will go here
            }
        }
        .navigationTitle("Servers")
    }
}
