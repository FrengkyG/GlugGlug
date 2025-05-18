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
    
    func currentWaterIntake() -> Int {
        return progress
    }
    
    func targetWaterIntake() -> Int {
        return UserDefaults(suiteName: "group.com.nfajarsa.GlugGlug")?.object(forKey: "goal") as? Int ?? 0
    }
}
