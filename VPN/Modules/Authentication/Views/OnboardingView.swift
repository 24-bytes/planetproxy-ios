import SwiftUI

struct OnboardingView: View {

    @State private var selectedTab = 0
    private let tabs = ["Get Started", "How it Works", "Features"]

    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                ForEach(tabs.indices, id: \.self) { index in
                    VStack(spacing: 20) {
                        Text(tabs[index])
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding()

                        Spacer()

                        if index == tabs.count - 1 {
                            Button("Get Started") {
                                // Handle completion action, e.g., dismissing the onboarding screen
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.bottom, 50)
                        } else {
                            Button("Next") {
                                withAnimation {
                                    selectedTab += 1
                                }
                            }
                            .buttonStyle(.bordered)
                            .padding(.bottom, 50)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

            HStack {
                if selectedTab < tabs.count - 1 {
                    Button("Skip") {
                        // Handle skip action, e.g., marking onboarding as completed
                        selectedTab = tabs.count - 1
                    }
                    .padding()
                }
            }
        }
    }
}
