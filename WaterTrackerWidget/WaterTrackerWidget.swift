//
//  WaterTrackerWidget.swift
//  WaterTrackerWidget
//
//  Created by Nur Fajar Sayyidul Ayyam on 14/05/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
    
    //    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct WaterTrackerWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack (alignment: .topTrailing) {
            VStack {
                CircularProgressView(progress: 0.8)
                    .padding(.top, 12)
                    .padding(.bottom, 6)
                
                Text("2000 ml")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("PrimaryColor"))
                Text("Remaining: 500 ml")
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
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
