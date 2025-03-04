import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        r = Double((int >> 16) & 0xFF) / 255.0
        g = Double((int >> 8) & 0xFF) / 255.0
        b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }

    static let customPurple = Color(hex: "#7F56D9")
    
    static let cardBg = Color(hex: "#15171D")
    
    static let fieldBg = Color(hex: "#374151")
    
    static let connectButton = Color(hex: "#A0FD71")
}
