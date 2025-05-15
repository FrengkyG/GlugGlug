//
//  CommonUtils.swift
//  GlugGlug
//
//  Created by Frengky Gunawan on 14/05/25.
//
import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var int: UInt64 = 0
        scanner.scanHexInt64(&int)
        let r, g, b: Double
        (r, g, b) = (
            Double((int >> 16) & 0xFF) / 255,
            Double((int >> 8) & 0xFF) / 255,
            Double(int & 0xFF) / 255
        )
        self.init(red: r, green: g, blue: b)
    }
}
