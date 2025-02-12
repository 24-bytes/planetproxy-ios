import SwiftUI

struct SupportView: View {
    @State private var subject = ""
    @State private var message = ""
    @State private var isShowingAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Contact Support")) {
                TextField("Subject", text: $subject)
                TextEditor(text: $message)
                    .frame(height: 150)
            }
            
            Section {
                Button("Submit") {
                    // TODO: Implement support ticket submission
                    isShowingAlert = true
                }
                .disabled(subject.isEmpty || message.isEmpty)
            }
            
            Section(header: Text("Other Support Options")) {
                Link(destination: URL(string: "mailto:support@planetproxy.com")!) {
                    Label("Email Support", systemImage: "envelope")
                }
                
                Link(destination: URL(string: "https://planetproxy.com/support")!) {
                    Label("Knowledge Base", systemImage: "book")
                }
                
                Link(destination: URL(string: "https://planetproxy.com/community")!) {
                    Label("Community Forum", systemImage: "person.3")
                }
            }
        }
        .navigationTitle("Support")
        .alert("Support Ticket Submitted", isPresented: $isShowingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("We'll get back to you as soon as possible.")
        }
    }
}

#Preview {
    SupportView()
}
