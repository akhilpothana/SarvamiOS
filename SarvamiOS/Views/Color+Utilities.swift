import SwiftUI

extension Color {
    init(_ hex: String) {
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

extension Color {
    static let backgroundLight = Color("fffbf4")
    static let buttonPrimary = Color("6b705c")
    static let buttonPurple = Color("4a2c4a")
    static let lightAccentBrown = Color("e27d60")
}

