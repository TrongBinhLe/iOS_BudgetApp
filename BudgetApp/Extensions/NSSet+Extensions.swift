//
//  NSSet+Extensions.swift
//  BudgetApp
//
//  Created by admin on 31/05/2023.
//

import Foundation

extension NSSet {
    func toArray<T>() -> [T] {
        let array = self.map({ $0 as! T})
        return array
    }
}
