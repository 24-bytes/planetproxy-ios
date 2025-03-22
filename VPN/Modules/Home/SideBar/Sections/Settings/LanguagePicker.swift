import SwiftUI

struct LanguagePicker: View {
    @Binding var selectedLanguage: String
    @Environment(\.presentationMode) var presentationMode

    let availableLanguages: [String] = Bundle.main.localizations.filter { $0 != "Base" } // Get all project localizations

    var body: some View {
        NavigationView {
            List(availableLanguages, id: \.self) { language in
                HStack {
                    Text(Locale.current.localizedString(forLanguageCode: language) ?? language) // Display localized name
                        .font(.system(size: 16))
                        .foregroundColor(.white)

                    Spacer()

                    if language == selectedLanguage {
                        Image(systemName: "checkmark")
                            .foregroundColor(.purple)
                    }
                }
                .padding(.vertical, 12)
                .listRowBackground(Color.black)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedLanguage = language
                    UserDefaults.standard.set(language, forKey: "selectedLanguage")
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .listStyle(PlainListStyle())
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
