struct OnboardingView: View {
    @State private var selectedTab = 0
    private let tabs = ["Get Started", "How it works", "Features"]

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(tabs.indices, id: \.self) { index in
                VStack {
                    Text(self.tabs[index])
                        .font(.largeTitle)
                        .padding()
                    Spacer()
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}

