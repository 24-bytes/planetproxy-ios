import SwiftUI

struct PlanSelectionView: View {
    @State private var selectedPlan: Plan?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Simple, transparent pricing")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Choose a plan that fits your needs.")
                .foregroundColor(.gray)
            
            ScrollView {
                VStack(spacing: 16) {
                    // Plan cards will go here
                }
            }
            
            Button(action: {}) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
