//
//  String+Extension.swift
//  BudgetApp
//
//  Created by admin on 19/05/2023.
//

import Foundation

extension String {
    
    var isNumeric: Bool {
        Double(self) != nil
    }
    
    func isGreatorThan(_ value: Double) -> Bool {
        guard self.isNumeric else { return false }
        return Double(self)! > value
    }
}
