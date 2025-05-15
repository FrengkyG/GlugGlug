//
//  WeeklyStatisticView.swift
//  GlugGlug
//
//  Created by Frengky Gunawan on 26/03/25.
//

import SwiftUI
import Charts

enum StatisticMode: String, CaseIterable {
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
}

struct ChartView: View {
    @Binding var selectedMode: StatisticMode
    @State private var dayDrink: [(String, Int)] = []
    @State private var selectedDate: String? = nil
    @State private var currentVolume: Int = 0
    
    var body: some View {
        VStack {
            if dayDrink.isEmpty {
                Text("Loading...")
            } else {
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading){
                        Text("Average").font(.system(size: 16, weight: .bold)).foregroundStyle(Color(hex: "#999999"))
                        HStack(alignment: .firstTextBaseline) {
                            Text("2.750").font(.system(size: 24, weight: .bold)).foregroundStyle(Color(hex: "#666666"))
                            Text("mL").font(.system(size: 16, weight: .bold)).foregroundStyle(Color(hex: "#999999"))
                        }
                    }.padding(.horizontal)
                    
                    
                    Chart(dayDrink, id: \.0) { (date, vol) in
                        BarMark(
                            x: .value("Day", date),
                            y: .value("Volume (mL)", vol)
                        )
                        .foregroundStyle(selectedDate == date ? Color.orange : Color.blue)
                        .annotation(position: .top) {
                            if (vol > 0) {
                                Text("\(Double(vol)/1000, specifier: "%.2f") L")
                                    .font(.footnote)
                                    .foregroundColor(selectedDate == date ? .orange : .blue)
                            }
                        }
                        
                        RuleMark(y: .value("goal", 2000))
                            .foregroundStyle(.red)
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                            .annotation(position: .trailing, alignment: .leading) {
                                Text("Goal\n2000 mL")
                                    .font(.system(size: 8))
                                    .padding(4)
                                    .background(Color.red)
                                    .cornerRadius(4)
                                    .foregroundStyle(.white)
                            }
                        
    
                        if selectedDate == date {
                            selectedDateRuleMark(date: date, volume: currentVolume)
                        }
                    }
                    
                    
                    .chartOverlay { proxy in
                        overlayGesture(proxy: proxy)
                    }
                    .chartXSelection(value: $selectedDate)
                    .chartXAxis{
                        AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                    }
                    .frame(height: 250)
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            loadStatistics()
        }.onChange(of: selectedMode) {
            loadStatistics()
        }
    }
    
    private func selectedDateRuleMark(date: String, volume: Int) -> some ChartContent {
        return RuleMark(x: .value("Day", date))
            .foregroundStyle(Color.orange)
            .lineStyle(StrokeStyle(lineWidth: 2))
            .annotation(position: .top, alignment: .center) {
                VStack(spacing: 4) {
                    Text("Volume")
                        .font(.caption2)
                        .foregroundColor(.white)
                    Text("\(volume) mL")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange)
                        .shadow(radius: 3)
                )
                .offset(y: 47)
            }
    }
    
    private func loadStatistics() {
        if selectedMode == .weekly {
            HealthKitManager.shared.getThisWeekStatistic { data in
                DispatchQueue.main.async {
                    self.dayDrink = data
                }
            }
        } else if selectedMode == .monthly {
            HealthKitManager.shared.getThisMonthStatistic { data in
                DispatchQueue.main.async {
                    self.dayDrink = data
                }
            }
        } else if selectedMode == .yearly {
            HealthKitManager.shared.getThisYearStatistic { data in
                DispatchQueue.main.async {
                    self.dayDrink = data
                }
            }
        }
        
    }
    
    @ViewBuilder
    private func overlayGesture(proxy: ChartProxy) -> some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { value in
                            if let date = proxy.value(atX: value.location.x, as: String.self) {
                                if let selectedItem = dayDrink.first(where: { $0.0 == date }) {
                                    selectedDate = selectedItem.0
                                    currentVolume = selectedItem.1
                                } else {
                                    selectedDate = nil
                                    currentVolume = 0
                                }
                            } else {
                                selectedDate = nil
                                currentVolume = 0
                            }
                        }
                )
        }
    }
}
