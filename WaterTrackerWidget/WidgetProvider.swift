//
//  WidgetProvider.swift
//  GlugGlug
//
//  Created by Nur Fajar Sayyidul Ayyam on 18/05/25.
//

import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    
    let data = DataService()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            currentIntake: data.currentWaterIntake(),
            targetIntake: data.targetWaterIntake(),
            isLogView: data.isLogViewActive()
        )
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        return SimpleEntry(
            date: Date(),
            currentIntake: data.currentWaterIntake(),
            targetIntake: data.targetWaterIntake(),
            isLogView: data.isLogViewActive()
        )
    }
    
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        
        let entry = SimpleEntry(
            date: Date(),
            currentIntake: data.currentWaterIntake(),
            targetIntake: data.targetWaterIntake(),
            isLogView: data.isLogViewActive()
        )
        return Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(1)))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let currentIntake: Int
    let targetIntake: Int
    let isLogView: Bool
}
