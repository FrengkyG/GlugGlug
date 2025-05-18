//
//  DataService.swift
//  GlugGlug
//
//  Created by Nur Fajar Sayyidul Ayyam on 16/05/25.
//


import Foundation
import SwiftUI

struct DataService {
    @AppStorage("progress", store: UserDefaults(suiteName: "group.com.nfajarsa.GlugGlug")) private var progress: Int = 0
    @AppStorage("isLogView", store: UserDefaults(suiteName: "group.com.nfajarsa.GlugGlug")) private var isLogView: Bool = false
    
    
    
    func currentWaterIntake() -> Int {
        return progress
    }
    
    func addWaterIntake(_ amount: Int) async {
        progress += amount
    }
    
    func targetWaterIntake() -> Int {
        return UserDefaults(suiteName: "group.com.nfajarsa.GlugGlug")?.object(forKey: "goal") as? Int ?? 2500
    }
    
    func setIsLogView(_ value: Bool) {
        isLogView = value
    }
    
    func isLogViewActive() -> Bool {
        return isLogView
    }
}
