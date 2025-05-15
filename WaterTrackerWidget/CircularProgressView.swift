//
//  CircularProgressView.swift
//  GlugGlug
//
//  Created by Nur Fajar Sayyidul Ayyam on 15/05/25.
//


import SwiftUI

struct CircularProgressView: View {
    var progress: Double // nilai antara 0.0 sampai 1.0
    var lineWidth: CGFloat = 10
    var size: CGFloat = 64
    var color: Color = Color("PrimaryColor")
    var icon: String = "drop.fill" // SF Symbol

    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)

            // Progress Circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90)) // Mulai dari atas
                .animation(.easeOut(duration: 0.5), value: progress)

            // Icon di tengah
            Image(systemName: icon)
                .font(.system(size: size * 0.3))
                .foregroundColor(color)
        }
        .frame(width: size, height: size)
    }
}
