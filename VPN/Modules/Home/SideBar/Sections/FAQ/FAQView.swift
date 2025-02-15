import SwiftUI

struct FAQView: View {
    @StateObject private var viewModel = FAQViewModel()

    var body: some View {
        VStack {
            // ✅ Header Section
            ToolbarView(title: "FAQ")

            // ✅ FAQ List
            ScrollView {
                VStack(spacing: 0) { // ✅ Removed spacing to align properly
                    ForEach(viewModel.faqItems) { item in
                        FAQItemView(item: item) {
                            viewModel.toggleItem(item)
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    }
}

struct FAQItemView: View {
    let item: FAQItem
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) { // ✅ No spacing for better alignment
            Button(action: action) {
                HStack {
                    Text("Q: \(item.question)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading) // ✅ Left-aligned

                    Image(systemName: item.isExpanded ? "minus" : "plus")
                        .foregroundColor(.gray)
                        .font(.system(size: 18, weight: .bold)) // ✅ Correct icon size
                }
                .padding(.vertical, 27) // ✅ Increased tap area
            }

            if item.isExpanded {
                Text(item.answer)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading) // ✅ Left-aligned answer
                    .padding(.bottom, 12) // ✅ Proper spacing before underline
            }

            Rectangle() // ✅ Grey underline
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.4))
                .padding(.top, 0) // ✅ Aligns perfectly with questions
        }
        .padding(.horizontal) // ✅ Ensures proper alignment
    }
}
