import SwiftUI

// 방금 톤 — 따뜻한 코랄 + 모래. Web globals.css / Android Color.kt 와 동일 hex.
extension Color {
    init(hex: UInt) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}

enum BG {
    static let brand = Color(hex: 0xF1644B)
    static let brandSoft = Color(hex: 0xFCE7E0)
    static let brandFg = Color.white
    static let sand = Color(hex: 0xFAF7F2)
    static let ink = Color(hex: 0x231F1B)
    static let card = Color.white
    static let muted = Color(hex: 0xEFE9E1)
    static let mutedFg = Color(hex: 0x7C736B)
    static let border = Color(hex: 0xE6DDD2)
    static let good = Color(hex: 0x31A07C)
    static let warn = Color(hex: 0xE5A11A)
}

// 카드 그림자 (Web shadow-card 근사)
extension View {
    func cardStyle(radius: CGFloat = 20) -> some View {
        self
            .background(BG.card)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}
