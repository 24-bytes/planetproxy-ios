import SwiftUI

struct CheckoutView: View {
    let plan: Plan?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Summary")
                .font(.title2)
                .fontWeight(.bold)
            
            // Order summary card
            VStack(alignment: .leading, spacing: 15) {
                if let plan = plan {
                    HStack {
                        Text("\(plan.name)")
                        Spacer()
                        Text("$\(plan.price, specifier: "%.2f")")
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Total")
                            .fontWeight(.bold)
                        Spacer()
                        Text("$\(plan.price, specifier: "%.2f")")
                            .fontWeight(.bold)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // Payment security info
            VStack(alignment: .leading, spacing: 10) {
                Label("Safe and secure payment", systemImage: "lock.shield")
                Label("14 day money back guarantee", systemImage: "clock")
            }
            
            Spacer()
            
            Button(action: {}) {
                Text("Subscribe")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
