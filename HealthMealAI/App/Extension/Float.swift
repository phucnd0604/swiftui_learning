//
//  Float.swift
//  HealthMealAI
//
//  Created by Phucnd on 26/7/25.
//


extension Float {
    
    var isInt: Bool {
        return self.truncatingRemainder(dividingBy: 1) == 0
    }
    
    
    var formatted: String {
        let rounded = (self * 10).rounded() / 10
        if rounded.isInt {
            return String(Int(rounded))
        } else {
            return String(format: "%.1f", rounded)
        }
    }
    

}
