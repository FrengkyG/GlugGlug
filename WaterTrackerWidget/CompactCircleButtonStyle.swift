//
//  CompactCircleButtonStyle.swift
//  GlugGlug
//
//  Created by Nur Fajar Sayyidul Ayyam on 15/05/25.
//

import SwiftUI

struct CompactCircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8) // padding internal kecil supaya icon lebih pas
            .background(Circle().fill(Color("PrimaryColor").opacity(0.1)))
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
