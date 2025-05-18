//
//  WaterTrackerWidget.swift
//  WaterTrackerWidget
//
//  Created by Nur Fajar Sayyidul Ayyam on 14/05/25.
//

import WidgetKit
import SwiftUI

enum WaterVolumeButton: Hashable, Encodable {
    case back
    case volume(Int)
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

struct WaterTrackerWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            CircularAccessoryView(entry:entry)
        default:
            ProgressWidgetView(entry: entry)
        }
    }
}

struct CircularAccessoryView: View {
    let entry: Provider.Entry
    
    var body: some View {
        VStack {
            CircularProgressView(progress: Double(entry.currentIntake) / Double(entry.targetIntake), lineWidth:9, size: 50)
                .padding()
        }
    }
}

struct ProgressWidgetView: View {
    let entry: Provider.Entry
    
    let buttons: [WaterVolumeButton] = [
        .volume(100),
        .back,
        .volume(250),
        .volume(500)
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
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
                    
                    Button(intent: SetLogViewIntent()) {
                        Image(systemName: "wineglass")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    .buttonStyle(CompactCircleButtonStyle(padding: 8))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                }
                .frame(width: geo.size.width)
                .offset(x: entry.isLogView ? -geo.size.width : geo.size.width / 2)
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(buttons, id: \.self) { button in
                        switch button {
                        case .back:
                            Button(intent: SetProgressViewIntent()) {
                                Image(systemName: "arrow.backward")
                                    .foregroundStyle(Color("PrimaryColor"))
                            }
                            .buttonStyle(CompactCircleButtonStyle(padding: 16))
                            
                        case .volume(let volume):
                            Button(intent: LogWaterIntakeIntent(volume)) {
                                VStack {
                                    Image(systemName: "wineglass")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(Color("PrimaryColor"))
                                    Text("\(volume) ml")
                                        .font(.caption)
                                        .foregroundColor(Color("PrimaryColor"))
                                }
                            }
                            .buttonStyle(RoundedBorderButtonStyle())
                        }
                    }
                }
                .padding()
                .frame(width: geo.size.width)
                .offset(x: entry.isLogView ? -geo.size.width / 2 : geo.size.width)
            }
            .frame(width: geo.size.width)
            .clipped()
            
        }
    }
}



#Preview(as: .systemSmall) {
    WaterTrackerWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        //        configuration: .smiley,
        currentIntake: 2900,
        targetIntake: 2500,
        isLogView: true
    )
}

