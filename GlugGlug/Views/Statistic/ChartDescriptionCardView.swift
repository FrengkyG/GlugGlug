//
//  ChartDescriptionCardView.swift
//  GlugGlug
//
//  Created by Frengky Gunawan on 15/05/25.
//

import SwiftUI

struct ChartDescriptionCardView: View {
    var selectedMode: StatisticMode = .weekly
    var achievedGoalCount: Int = 0
    var totalData: Int = 0
    private var averageDataCount: Int {
        Int(ceil(Double(totalData) / 2.0))
    }
    
    @State private var goodDescription: [String] = [
        "Awesome job! You hit your water goal [achieved] times out of [total] [unit]! 🔥",
        "Great job! You stayed on track [achieved] out of [total] [unit] — hydration progress is real!💦🎯",
        "Great work! You nailed your hydration goals in [achieved] out of [total] [unit] — that’s solid progress! 💪🚰",
        "You’re a hydration hero! Smashed your goal [achieved] out of [total] [unit]! 🌟",
        "Wow, [achieved] out of [total] [unit] on target — your hydration game is strong! 💧",
        "Fantastic effort! You hit your water goal [achieved] times in [total] [unit]! 🚀",
        "Hydration win! You reached your goal [achieved] out of [total] [unit] — keep shining! ✨",
        "Incredible! You crushed it with [achieved] out of [total] [unit] on point! 💥"
    ]
    
    @State private var badDescription: [String] = [
        "You hit your water goal [achieved] out of [total] [unit]. Let’s step it up! 💧",
        "You reached your goal [achieved] out of [total] [unit]. Time to boost your hydration game! 🚰",
        "Your goal was hit [achieved] out of [total] [unit]. Let’s aim higher next [period]! 🌊",
        "Only [achieved] out of [total] [unit]? No worries, we’ll get there next [period]! 💦",
        "You got [achieved] out of [total] [unit]. Let’s ramp up your hydration! 🥤",
        "Reached [achieved] out of [total] [unit]. Time to make hydration a priority! 🌧️",
        "You’re at [achieved] out of [total] [unit]. Let’s make more [unit] count next [period]! 💪",
        "Just [achieved] out of [total] [unit]? Let’s hydrate more next [period]! 🚿"
    ]
    
    @State private var goodActionPlan: [String] = [
        "Go for a perfect streak next week — you’re super close!",
        "Add a quick water check-in after meals",
        "Pair water time with habits you already do (e.g. before meals or after brushing teeth)",
        "Set a morning reminder to kickstart your water intake for the day.",
        "Stay hydrated to keep your energy up and skin glowing!",
    ]
    
    @State private var badActionPlan: [String] = [
        "Drink 1 glass right after waking up every day!",
        "Don’t forget to set your reminder and keep a bottle within reach",
        "Set a daily reminder and keep water in sight — out of sight = out of sip!",
        "Start small: aim for half your goal by midday to build momentum.",
        "Try drinking a glass before each meal to get closer to your goal.",
    ]
    
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: achievedGoalCount >= averageDataCount ? "warninglight.fill" : "exclamationmark.warninglight.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
                .foregroundColor(achievedGoalCount >= averageDataCount ? .blue : Color(hex: "#FFD500"))
            VStack(alignment: .leading, spacing: 4) {
                Text(getDescription()).font(.system(size: 12))
                Text(achievedGoalCount >= averageDataCount ?
                     goodActionPlan.randomElement() ?? "Keep it up!" :
                        badActionPlan.randomElement() ?? "Try harder next time!").font(.system(size: 14)).bold()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(achievedGoalCount >= averageDataCount ? Color.blue.opacity(0.1) : Color(hex: "#FFF7CB"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(achievedGoalCount >= averageDataCount ? Color.blue.opacity(0.2) : Color(hex: "#FFD500"), lineWidth: 2)
        )
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding()
    }
    private func getDescription() -> String {
        let descriptionArray = achievedGoalCount >= averageDataCount ? goodDescription : badDescription
        return replacePlaceholders(descriptionArray.randomElement() ?? "Keep hydrating!")
    }
    
    private func replacePlaceholders(_ text: String) -> String {
        var result = text
        result = result.replacingOccurrences(of: "[achieved]", with: "\(achievedGoalCount)")
        result = result.replacingOccurrences(of: "[total]", with: "\(totalData)")
        result = result.replacingOccurrences(of: "[unit]", with: unitForMode())
        result = result.replacingOccurrences(of: "[period]", with: periodForMode())
        result = result.replacingOccurrences(of: "[avg]", with: "\(averageDataCount)")
        return result
    }
    
    private func unitForMode() -> String {
        switch selectedMode {
        case .weekly: return "days"
        case .monthly: return "weeks"
        case .yearly: return "months"
        }
    }
    
    private func periodForMode() -> String {
        switch selectedMode {
        case .weekly: return "week"
        case .monthly: return "month"
        case .yearly: return "year"
        }
    }
}

#Preview {
    ChartDescriptionCardView()
}
