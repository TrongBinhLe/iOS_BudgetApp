//
//  Double+Extension.swift
//  BudgetApp
//
//  Created by admin on 31/05/2023.
//

import Foundation

extension Double {
    
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "0.0"
    }
}
