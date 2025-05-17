//
//  ShortcutsIntent.swift
//  GlugGlug
//
//  Created by Frengky Gunawan on 16/05/25.
//
import AppIntents

struct AppIntentShortcutProvider: AppShortcutsProvider {
    
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: HydrationInsight(),
            phrases: ["Get Hydration Insight in \(.applicationName)"],
            shortTitle: "Hydration Insight",
            systemImageName: "drop.fill"
        )
        
    }
    
}

struct HydrationInsight: AppIntent {
    static var title: LocalizedStringResource = "Get Hydration Insight"
    static var description = IntentDescription("Provides a hydration description and motivational message based on progress.")
    
    static var openAppWhenRun: Bool = false
    
    @MainActor
    func perform() async throws -> some ProvidesDialog {
        let data = await HealthKitManager.shared.getThisWeekStatisticAsync()
        
        let totalDays = data.count
        let goalTarget = 2000
        let achievedDays = data.filter { $0.volume >= goalTarget }.count
        let averageDataCount = Int(ceil(Double(totalDays) / 2.0))
        
        let isGood = achievedDays >= averageDataCount
        
        let goodDescription = [
            "Awesome job! You hit your water goal [achieved] times out of [total] days! 🔥",
            "Great job! You stayed on track [achieved] out of [total] days — hydration progress is real!💦🎯",
            "Great work! You nailed your hydration goals in [achieved] out of [total] days — that’s solid progress! 💪🚰",
            "You’re a hydration hero! Smashed your goal [achieved] out of [total] days! 🌟",
            "Wow, [achieved] out of [total] days on target — your hydration game is strong! 💧",
            "Fantastic effort! You hit your water goal [achieved] times in [total] days! 🚀",
            "Hydration win! You reached your goal [achieved] out of [total] days — keep shining! ✨",
            "Incredible! You crushed it with [achieved] out of [total] days on point! 💥"
        ]
        
        let badDescription = [
            "You hit your water goal [achieved] out of [total] days. Let’s step it up! 💧",
            "You reached your goal [achieved] out of [total] days. Time to boost your hydration game! 🚰",
            "Your goal was hit [achieved] out of [total] days. Let’s aim higher next week! 🌊",
            "Only [achieved] out of [total] days? No worries, we’ll get there next week! 💦",
            "You got [achieved] out of [total] days. Let’s ramp up your hydration! 🥤",
            "Reached [achieved] out of [total] days. Time to make hydration a priority! 🌧️",
            "You’re at [achieved] out of [total] days. Let’s make more days count next week! 💪",
            "Just [achieved] out of [total] days? Let’s hydrate more next week! 🚿"
        ]
        
        let goodActionPlan = [
            "Go for a perfect streak next week — you’re super close!",
            "Add a quick water check-in after meals",
            "Pair water time with habits you already do (e.g. before meals or after brushing teeth)",
            "Set a morning reminder to kickstart your water intake for the day.",
            "Stay hydrated to keep your energy up and skin glowing!",
        ]
        
        let badActionPlan = [
            "Drink 1 glass right after waking up every day!",
            "Don’t forget to set your reminder and keep a bottle within reach",
            "Set a daily reminder and keep water in sight — out of sight = out of sip!",
            "Start small: aim for half your goal by midday to build momentum.",
            "Try drinking a glass before each meal to get closer to your goal.",
        ]
        
        let descTemplate = (isGood ? goodDescription : badDescription).randomElement() ?? ""
        let action = (isGood ? goodActionPlan : badActionPlan).randomElement() ?? ""
        
        let description = descTemplate
            .replacingOccurrences(of: "[achieved]", with: "\(achievedDays)")
            .replacingOccurrences(of: "[total]", with: "\(totalDays)")
        
        let finalResult = "\(description)\n\n 💡Tips: \(action)"
        return .result(dialog: "\(finalResult)")
        
    }
}
