import SwiftUI
import StoreKit

struct RateUsView: View {
    @State private var rating: Int = 0
    @State private var feedback = ""
    @State private var isShowingAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Enjoying PlanetProxy?")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Your feedback helps us improve!")
                .foregroundColor(.secondary)
            
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.title)
                        .onTapGesture {
                            rating = index
                        }
                }
            }
            .padding()
            
            if rating > 0 {
                if rating >= 4 {
                    VStack {
                        Text("Great! Would you mind rating us on the App Store?")
                        
                        Button("Rate on App Store") {
                            // TODO: Implement SKStoreReviewController request
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    VStack {
                        Text("How can we improve?")
                        TextEditor(text: $feedback)
                            .frame(height: 100)
                            .border(Color.secondary.opacity(0.2))
                            .padding()
                        
                        Button("Submit Feedback") {
                            // TODO: Implement feedback submission
                            isShowingAlert = true
                            feedback = ""
                            rating = 0
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(feedback.isEmpty)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Rate Us")
        .alert("Thank You!", isPresented: $isShowingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("We appreciate your feedback!")
        }
    }
}

#Preview {
    RateUsView()
}
