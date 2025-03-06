import SwiftUI
import StoreKit

struct RateUsView: View {
    @State private var rating: Int = 0
    @State private var feedback = ""
    @State private var isShowingAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            ToolbarView(title: "Rate Us")
            
            Text("Enjoying PlanetProxy?")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Your feedback helps us improve!")
                .foregroundColor(.gray)
            
            HStack {
                ForEach(1...5, id: \..self) { index in
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
                    VStack(spacing: 10) {
                        Text("Great! Would you mind rating us on the App Store?")
                            .foregroundColor(.white)
                        
                        Button(action: {
                            requestAppStoreReview()
                        }) {
                            Text("Rate Now")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.customPurple)
                        .padding(.horizontal)
                    }
                } else {
                    VStack(spacing: 10) {
                        Text("How can we improve?")
                            .foregroundColor(.white)
                        
                        TextEditor(text: $feedback)
                            .frame(height: 100)
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        Button(action: {
                            isShowingAlert = true
                            feedback = ""
                            rating = 0
                        }) {
                            Text("Submit Feedback")
                        }
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.customPurple)
                        .cornerRadius(10)
                        .disabled(feedback.isEmpty)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .alert("Thank You!", isPresented: $isShowingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("We appreciate your feedback!")
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // ✅ Function to request in-app App Store rating
    private func requestAppStoreReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            AppStore.requestReview(in: windowScene)
        }
    }
}
