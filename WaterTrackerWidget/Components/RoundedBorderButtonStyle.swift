//
//  RoundedBorderButtonStyle.swift
//  GlugGlug
//
//  Created by Nur Fajar Sayyidul Ayyam on 18/05/25.
//

import SwiftUI

struct RoundedBorderButtonStyle: ButtonStyle {
    var width: CGFloat = 42
    var height: CGFloat = 42

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width, height: height)
            .foregroundColor(Color("PrimaryColor"))
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("PrimaryColor").opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color("PrimaryColor"), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
    }
}
