//
//  EditGoalView.swift
//  GlugGlug
//
//  Created by Nur Fajar Sayyidul Ayyam on 27/03/25.
//

import SwiftUI


struct EditGoalView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var selectedSegment = 0
    
    var body: some View {
        NavigationStack {
            VStack () {
                Picker("Options", selection: $selectedSegment) {
                    Text("Manual").tag(0)
                    Text("By Body Weight").tag(1)
                    
                }
                .pickerStyle(.segmented)
                
                Spacer()
                
                if selectedSegment == 0 {
                    CustomView()
                } else {
                    RecommendationView()
                }
                Spacer()
            }
            .padding(.horizontal)
            .presentationDetents([.fraction(0.58)])
            .toolbar {
                ToolbarItem(placement: .principal) { // Title di tengah
                    Text("Edit Goal")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct RecommendationView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            //            AlertBanner(message: "💦 Just enter your weight, and we’ll tell you how much water you need daily! 😊", iconName: "lightbulb.fill", backgroundColor: Color.blue.opacity(0.1), foregroundColor: Color.blue, textColor: .primary)
            Text("\(Int(calculateDailyWaterRequirement(weightKg: Double(homeViewModel.weight))))")
                .font(.largeTitle)
            +
            Text(" ml")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            HStack {
                Spacer()
                
                Picker(selection: $homeViewModel.weight, label: Text("")) {
                    ForEach(30...150, id: \.self) { weight in
                        Text("\(weight)") // Hanya angka di Wheel
                            .font(.title2)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 180)
                .clipped()
                
                Text("Kg")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            Spacer()
            
            Button {
                homeViewModel.editGoal(Int(calculateDailyWaterRequirement(weightKg: Double(homeViewModel.weight))))
                dismiss()
            } label: {
                Text("Set your target")
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.horizontal)
        }
    }
    
    func calculateDailyWaterRequirement(weightKg: Double) -> Int {
        if weightKg <= 10 {
            return Int(weightKg * 100)
        } else if weightKg <= 20 {
            return Int((10 * 100) + ((weightKg - 10) * 50))
        } else {
            return Int((10 * 100) + (10 * 50) + ((weightKg - 20) * 20))
        }
    }

}

struct CustomView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var inputValue: String = "0"
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    let numbers = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["00", "0", "⌫"]
    ]
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(inputValue)")
                .font(.largeTitle)
            +
            Text(" ml")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(numbers, id: \.self) { row in
                    ForEach(row, id: \.self) { item in
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            handleInput(item)
                        }) {
                            Text(item)
                                .font(.title)
                                .frame(width: 100, height: 40)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                }
            }
            
            Spacer()
            
            Button {
                if (Int(inputValue) ?? 0) < 10 {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    
                    return
                } else if (Int(inputValue) ?? 0) > 10000 {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    return
                }
                homeViewModel.editGoal(Int(inputValue) ?? 0)
                dismiss()
            } label: {
                Text("Set your target")
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.horizontal)
        }
        
    }
    
    func handleInput(_ value: String) {
        if value == "⌫" {
            if inputValue.count == 1 {
                inputValue = "0"  // Kalau tinggal 1 angka, reset ke "0"
            } else {
                inputValue.removeLast()
            }
        } else if value == "00" && inputValue == "0" {
            return  // Jika input "0" lalu tekan "00", tetap jadi "0"
        } else {
            if inputValue == "0" || inputValue == "00"{
                inputValue = value // Ganti langsung kalau masih "0"
            }
            else {
                inputValue.append(value)
            }
        }
    }
    
}


#Preview {
    EditGoalView()
        .environmentObject(HomeViewModel())
}

