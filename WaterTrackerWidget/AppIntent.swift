//
//  AppIntent.swift
//  WaterTrackerWidget
//
//  Created by Nur Fajar Sayyidul Ayyam on 14/05/25.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Water Tracker" }
    static var description: IntentDescription { "View your water intake Progress." }
}

struct SetLogViewIntent: AppIntent {
    static var title: LocalizedStringResource = "Set Log View Off"

    func perform() async throws -> some IntentResult {
        let defaults = UserDefaults(suiteName: "group.com.nfajarsa.GlugGlug")
        defaults?.set(true, forKey: "isLogView")
        print(defaults?.object(forKey: "isLogView") as Any)
        return .result()
    }
}

struct SetProgressViewIntent: AppIntent {
    static var title: LocalizedStringResource = "Set Log View Off"

    func perform() async throws -> some IntentResult {
        let defaults = UserDefaults(suiteName: "group.com.nfajarsa.GlugGlug")
        defaults?.set(false, forKey: "isLogView")
        return .result()
    }
}

struct LogWaterIntakeIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Water Intake"
    static var description = IntentDescription("Add water intake to your daily log.")
    
    init() {
        self.amount = 0
     }
     
     init(_ amount: Int) {
      self.amount = amount
     }
    
    @Parameter(title: "Amount (ml)")
    var amount: Int
    
    let data = DataService()

    func perform() async throws -> some IntentResult {
        AudioManager.shared.playSound(named: "liquid-bubble.wav")
        HealthKitManager.shared.addWaterAmount(volume: Double(amount))
        
        let defaults = UserDefaults(suiteName: "group.com.nfajarsa.GlugGlug")
        defaults?.set(false, forKey: "isLogView")
        
        try await Task.sleep(nanoseconds: 500_000_000)
        await data.addWaterIntake(amount)
        
        return .result()
    }
}
