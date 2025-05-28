//
//  HealthKitManager.swift
//  GlugGlug
//
//  Created by Frengky Gunawan on 19/03/25.
//

import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    private let volumeUnit = HKUnit.literUnit(with: .milli)
    private let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)
    
    private var healthStore = HKHealthStore()
    
    func addWaterAmount(volume : Double, date: Date = Date()) {
        guard let quantityType = self.waterType else {
            print("Error: dietaryWater quantity type is nil")
            return
        }
        
        let drinkAmount = HKQuantity(unit: volumeUnit, doubleValue: volume)
        
        let data = HKQuantitySample(type: quantityType, quantity: drinkAmount, start: date, end: date)
        self.healthStore.save(data) { success, error in
            if let error = error {
                print("Error saving water data: \(error.localizedDescription)")
            } else {
                print("Successfully saved water intake: \(volume) mL")
            }
        }
    }
    
}
