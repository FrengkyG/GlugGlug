//
//  CompactCircleButtonStyle.swift
//  GlugGlug
//
//  Created by Nur Fajar Sayyidul Ayyam on 15/05/25.
//

import SwiftUI

struct CompactCircleButtonStyle: ButtonStyle {
    let padding: CGFloat
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(padding) // padding internal kecil supaya icon lebih pas
            .background(Circle().fill(Color("PrimaryColor").opacity(0.15)))
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
    }
}
