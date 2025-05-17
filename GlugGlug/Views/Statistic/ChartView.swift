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
    @State private var goal: Int = 2500
    @State private var averageIntake: Int = 0
    @State private var achievedGoalCount: Int = 0
    @State private var totalData: Int = 0
    
    var body: some View {
        VStack {
            if dayDrink.isEmpty {
                Text("Loading...")
            } else {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading){
                        Text("Average").font(.system(size: 16, weight: .bold)).foregroundStyle(Color(hex: "#999999"))
                        HStack(alignment: .firstTextBaseline) {
                            Text("\(averageIntake)").font(.system(size: 24, weight: .bold)).foregroundStyle(Color(hex: "#666666"))
                            Text("mL").font(.system(size: 16, weight: .bold)).foregroundStyle(Color(hex: "#999999"))
                        }
                    }.padding(.horizontal)
                    
                    
                    Chart(dayDrink, id: \.0) { (date, vol) in
                        BarMark(
                            x: .value("Day", date),
                            y: .value("Volume (mL)", vol)
                        )
                        .foregroundStyle(selectedDate == date ? Color.mint : Color.blue)
                        
                        RuleMark(y: .value("goal", goal))
                            .foregroundStyle(.red)
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                            .annotation(position: .trailing, alignment: .leading) {
                                Text("Goal\n\(goal) mL")
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
                    .chartYScale(domain: 0...maxYValue())
                    .frame(height: 175)
                    .padding(.horizontal)
                }
                ChartDescriptionCardView(selectedMode: selectedMode, achievedGoalCount: achievedGoalCount, totalData: totalData)
            }
        }
        .onAppear {
            loadStatistics()
            getGoal()
        }.onChange(of: selectedMode) {
            loadStatistics()
        }
    }
    
    private func maxYValue() -> Int {
        var maxWithBuffer: Int = 3000
        let maxDrinkVolume = dayDrink.map { $0.1 }.max() ?? 2000
        
        if (maxDrinkVolume < goal) {
            maxWithBuffer = goal + 500
        } else {
            maxWithBuffer = maxDrinkVolume + 500
        }
        
        maxWithBuffer = Int(ceil(Double(maxWithBuffer) / 1000.0)) * 1000

        return max(maxWithBuffer, goal)
    }
    
    private func selectedDateRuleMark(date: String, volume: Int) -> some ChartContent {
        //        return RuleMark(x: .value("Day", date))
        //            .foregroundStyle(Color.orange)
        //            .lineStyle(StrokeStyle(lineWidth: 2))
        //            .annotation(position: .top, alignment: .center) {
        //                VStack(spacing: 4) {
        //                    Text("Volume")
        //                        .font(.caption2)
        //                        .foregroundColor(.white)
        //                    Text("\(volume) mL")
        //                        .font(.caption)
        //                        .fontWeight(.bold)
        //                        .foregroundColor(.white)
        //                }
        //                .padding(6)
        //                .background(
        //                    RoundedRectangle(cornerRadius: 8)
        //                        .fill(Color.orange)
        //                        .shadow(radius: 3)
        //                )
        //                .offset(y: 47)
        //            }
        return PointMark(
            x: .value("Day", date),
            y: .value("Volume (mL)", volume)
        )
        .foregroundStyle(Color.mint)
        .symbolSize(100)
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
                    .fill(Color.mint)
                    .shadow(radius: 3)
            )
        }
    }
    
    private func loadStatistics() {
        if selectedMode == .weekly {
            HealthKitManager.shared.getThisWeekStatistic { data in
                DispatchQueue.main.async {
                    self.dayDrink = data
                    self.averageIntake = data.map { $0.1 }.reduce(0, +) / max(data.count, 1)
                    self.achievedGoalCount = data.filter { $0.1 >= self.goal }.count
                    self.totalData = data.count
                }
            }
        } else if selectedMode == .monthly {
            HealthKitManager.shared.getThisMonthStatistic { data in
                DispatchQueue.main.async {
                    self.dayDrink = data
                    self.averageIntake = data.map { $0.1 }.reduce(0, +) / max(data.count, 1)
                    self.achievedGoalCount = data.filter { $0.1 >= self.goal }.count
                    self.totalData = data.count
                }
            }
        } else if selectedMode == .yearly {
            HealthKitManager.shared.getThisYearStatistic { data in
                DispatchQueue.main.async {
                    self.dayDrink = data
                    self.averageIntake = data.map { $0.1 }.reduce(0, +) / max(data.count, 1)
                    self.achievedGoalCount = data.filter { $0.1 >= self.goal }.count
                    self.totalData = data.count
                }
            }
        }
    }
    
    private func getGoal() {
        goal = (UserDefaults.standard.object(forKey: "goal") as? Int) ?? 2500
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
