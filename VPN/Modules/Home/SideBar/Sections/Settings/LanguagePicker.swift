import SwiftUI

struct LanguagePicker: View {
    @Binding var selectedLanguage: String
    @Environment(\.presentationMode) var presentationMode

    let languages = ["English (Default)", "Spanish", "French", "German", "Japanese"]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List(languages, id: \.self) { language in
                    HStack {
                        Text(language)
                            .font(.system(size: 16))
                            .foregroundColor(.white)

                        Spacer()

                        if language == selectedLanguage {
                            Image(systemName: "checkmark")
                                .foregroundColor(.purple)
                        }
                    }
                    .padding(.vertical, 12)
                    .listRowBackground(Color.black) // ✅ Ensures each row has a black background
                    .contentShape(Rectangle()) // ✅ Entire row is clickable
                    .onTapGesture {
                        selectedLanguage = language
                        UserDefaults.standard.set(language, forKey: "selectedLanguage") // ✅ Save selection
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden) // ✅ Hides default list background
                .background(Color.black) // ✅ Full black background
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("Select Language")
            .foregroundColor(.white)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.purple)
                }
            }
        }
    }
}

// ✅ Preview for Testing
struct LanguagePicker_Previews: PreviewProvider {
    static var previews: some View {
        LanguagePicker(selectedLanguage: .constant("English (Default)"))
    }
}
