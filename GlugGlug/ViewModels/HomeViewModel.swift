//
//  HomeViewModel.swift
//  GlugGlug
//
//  Created by Nur Fajar Sayyidul Ayyam on 27/03/25.
//

import Foundation
import WidgetKit

class HomeViewModel: ObservableObject {
    
    @Published var goal: Int {
        didSet {
            UserDefaults(suiteName: "group.com.nfajarsa.GlugGlug")?.set(goal, forKey: "goal")
            WidgetCenter.shared.reloadTimelines(ofKind: "WaterTrackerWidget")
        }
    }
    
//    @Published var current: Int {
//        didSet {
//            UserDefaults(suiteName: "group.com.nfajarsa.glugglug")?.set(current, forKey: "current")
//            WidgetCenter.shared.reloadTimelines(ofKind: "WaterTrackerWidget")
//        }
//    }
    
    @Published var glassOptions: [GlassOption] = [] {
        didSet {
            saveGlassOptions()
        }
    }
    
    @Published var weight: Int {
        didSet { UserDefaults(suiteName: "group.com.nfajarsa.GlugGlug")?.set(weight, forKey: "weight") }
    }
    
    init() {
        let savedGoal = UserDefaults(suiteName: "group.com.nfajarsa.GlugGlug")?.object(forKey: "goal") as? Int
        let savedWeight = UserDefaults(suiteName: "group.com.nfajarsa.GlugGlug")?.object(forKey: "weight") as? Int
//        let savedCurrent = UserDefaults(suiteName: "group.com.nfajarsa.glugglug")?.object(forKey: "current") as? Int

        self.goal = savedGoal ?? 2500
        self.weight = savedWeight ?? 70
//        self.current = savedCurrent ?? 0
        self.glassOptions = self.loadGlassOptions()
    }
    
//    func updateWaterIntake(current: Int, goal: Int) {
//        if let userDefaults = UserDefaults(suiteName: "group.com.nfajarsa.glugglug") {
//            userDefaults.set(current, forKey: "current")
//            userDefaults.set(goal, forKey: "goal")
//        }
//        
//        // Minta widget reload timeline agar data langsung update
//        WidgetCenter.shared.reloadTimelines(ofKind: "WaterTrackerWidget")
//    }

    
    func editWeight(_ newWeight: Int) {
        weight = newWeight
    }
    
    func editGoal(_ newGoal: Int) {
        goal = newGoal
    }
    
//    func editCurrent(_ newCurrent: Int) {
//        current = newCurrent
//    }
    
    func addGlass(icon: String, amount: Int) {
        let newGlass = GlassOption(icon: icon, amount: amount)
        glassOptions.append(newGlass)
        glassOptions.sort(by: { $0.amount < $1.amount })
        saveGlassOptions()
    }
    
    func removeGlass(at index: Int) {
        guard glassOptions.indices.contains(index) else { return }
        glassOptions.remove(at: index)
        saveGlassOptions()
    }
    
    private func saveGlassOptions() {
        if let encoded = try? JSONEncoder().encode(glassOptions) {
            UserDefaults(suiteName: "group.com.nfajarsa.GlugGlug")?.set(encoded, forKey: "glassOptions")
        }
    }
    
    private func loadGlassOptions() -> [GlassOption] {
        if let data = UserDefaults(suiteName: "group.com.nfajarsa.GlugGlug")?.data(forKey: "glassOptions"),
           let decoded = try? JSONDecoder().decode([GlassOption].self, from: data) {
            return decoded
        }
        return [
            GlassOption(icon: "cup.and.saucer.fill", amount: 100),
            GlassOption(icon: "mug.fill", amount: 1000),
            GlassOption(icon: "takeoutbag.and.cup.and.straw.fill", amount: 2000),
        ]
    }
}
