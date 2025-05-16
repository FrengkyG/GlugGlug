//
//  WaterTrackerWidget.swift
//  WaterTrackerWidget
//
//  Created by Nur Fajar Sayyidul Ayyam on 14/05/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    
    let data = DataService()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            configuration: ConfigurationAppIntent(),
            currentIntake: data.currentWaterIntake(),
            targetIntake: 2500
        )
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let targetIntake = (UserDefaults(suiteName: "group.com.nfajarsa.GlugGlug")?.object(forKey: "goal") as? Int) ?? 2500
        return SimpleEntry(
            date: Date(),
            configuration: configuration,
            currentIntake: data.currentWaterIntake(),
            targetIntake: targetIntake
        )
    }

    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let targetIntake = (UserDefaults(suiteName: "group.com.nfajarsa.GlugGlug")?.object(forKey: "goal") as? Int) ?? 2500
        print(targetIntake)
        print(data.currentWaterIntake())

        let entry = SimpleEntry(
            date: Date(),
            configuration: configuration,
            currentIntake: data.currentWaterIntake(),
            targetIntake: targetIntake
        )
        return Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(1)))
    }

    
    //    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    
    let currentIntake: Int
    let targetIntake: Int
}

struct WaterTrackerWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack (alignment: .topTrailing) {
            VStack {
                CircularProgressView(progress: Double(entry.currentIntake) / Double(entry.targetIntake))
                    .padding(.top, 12)
                    .padding(.bottom, 6)

                Text("\(entry.currentIntake) ml")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("PrimaryColor"))

                Text(entry.currentIntake >= entry.targetIntake ? "Target Reached!" : "Remaining: \(entry.targetIntake - entry.currentIntake) ml")
                    .font(.caption)
                    .foregroundStyle(Color("Gray"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action: {
                // Aksi button (opsional untuk widget)
            }) {
                Image(systemName: "wineglass")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color("PrimaryColor"))
            }
            .buttonStyle(CompactCircleButtonStyle())
            .padding(.vertical, 4)
            .padding(.horizontal, 8)

        }
    }
}

struct WaterTrackerWidget: Widget {
    let kind: String = "WaterTrackerWidget"
    
    var backgroundColors: [Color] {
        return [Color("GradientStart"), Color("GradientEnd")]
    }
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WaterTrackerWidgetEntryView(entry: entry)
                .containerBackground(LinearGradient(
                    gradient: Gradient(colors: backgroundColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ), for: .widget)
        }
        .supportedFamilies([.systemSmall, .accessoryCircular])
        .contentMarginsDisabled()
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    WaterTrackerWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        configuration: .smiley,
        currentIntake: 2900,
        targetIntake: 2500
    )
}

