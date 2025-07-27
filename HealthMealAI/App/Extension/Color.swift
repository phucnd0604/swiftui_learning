    //
    //  Color.swift
    //  HealthMealAI
    //
    //  Created by Phucnd on 26/7/25.
    //

import SwiftUI

extension Color {
    // MARK: - Custom Colors with Hex Values
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r, g, b, a: Double
        switch hexSanitized.count {
            case 6:
                r = Double((rgb & 0xFF0000) >> 16) / 255
                g = Double((rgb & 0x00FF00) >> 8) / 255
                b = Double(rgb & 0x0000FF) / 255
                a = 1.0
            case 8:
                a = Double((rgb & 0xFF000000) >> 24) / 255
                r = Double((rgb & 0x00FF0000) >> 16) / 255
                g = Double((rgb & 0x0000FF00) >> 8) / 255
                b = Double(rgb & 0x000000FF) / 255
            default:
                r = 1.0
                g = 1.0
                b = 1.0
                a = 1.0
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
    
}
