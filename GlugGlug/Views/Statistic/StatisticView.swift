//
//  StatisticView.swift
//  GlugGlug
//
//  Created by Frengky Gunawan on 19/03/25.
//

import SwiftUI
import Charts

struct StatisticView: View {
    @StateObject var healthKitManager = HealthKitManager.shared
    @State private var selectedMode: StatisticMode = .weekly
    @State private var streak: Int = 0
    @State private var goalAchieved: Int = 0
    
    @State private var showAddManualView: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack {
                HStack {
                    switch selectedMode {
                    case .weekly:
                        Text("This Week")
                            .font(.title3)
                            .foregroundStyle(.gray)
                    case .monthly:
                        Text("This Month")
                            .font(.title3)
                            .foregroundStyle(.gray)
                    case .yearly:
                        Text("This Year")
                            .font(.title3)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                Picker("", selection: $selectedMode) {
                    Text("Week").tag(StatisticMode.weekly)
                    Text("Month").tag(StatisticMode.monthly)
                    Text("Year").tag(StatisticMode.yearly)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                ChartView(selectedMode: $selectedMode)
                
                HStack {
                    Image(systemName: "warninglight.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .foregroundColor(.blue)
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Awesome job! You hit your water goal 4 out of 7 days! 🔥").font(.footnote).italic()
                        Text("Go for a perfect streak next week — you’re super close!").font(.footnote).bold()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill( Color.blue.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 2)
                )
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                .padding()
                
                
                HStack {
                    Spacer()
                    
                    StatCardView(
                        iconName: "flame.fill",
                        title: "Streak",
                        value: "\(streak) \(streak == 1 ? "Day" : "Days")",
                        backgroundColor: Color.blue.opacity(0.1)
                    )
                    
                    Spacer()
                    
                    StatCardView(
                        iconName: "checkmark.seal.fill",
                        title: "Goal Hits",
                        value: "\(goalAchieved) \(goalAchieved == 1 ? "Time" : "Times")",
                        backgroundColor: Color.blue.opacity(0.1)
                    )
                    
                    Spacer()
                }
                .padding(.horizontal, 8)
                
                Spacer()
            }
            .navigationTitle("Statistics")
            .navigationBarItems(
                trailing: Button(action: {
                    showAddManualView.toggle()
                }) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 20, weight: .bold))
                }
            )
            .sheet(isPresented: $showAddManualView) {
                AddManualView()
            }
        }
        .onAppear {
            HealthKitManager.shared.getStreak { streak in
                self.streak = streak
            }
            HealthKitManager.shared.getGoalAchieved { goal in
                self.goalAchieved = goal
            }
        }
        .tabItem {
            Image(systemName: "chart.bar.fill")
            Text("Statistic")
        }
    }
}

struct StatisticInformationView: View {
    let title: String
    let value: String
    let imageName: String
    
    var body: some View {
        HStack {
            VStack {
                Text(title).font(.callout).italic()
                Text(value).bold()
            }
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
                .foregroundColor(.blue)
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(lineWidth: 2).foregroundColor(.blue))
    }
}

#Preview {
    StatisticView()
}
