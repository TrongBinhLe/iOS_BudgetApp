//
//  BudgetCategory+CoreDataClass.swift
//  BudgetApp
//
//  Created by admin on 31/05/2023.
//

import Foundation
import CoreData

@objc(BudgetCategory)
public class BudgetCategory: NSManagedObject {

    var transactionTotal: Double {
        let transactionsArray:[Transaction] = transactions?.toArray() ?? []
        return transactionsArray.reduce(0) { next, transaction in
            next + transaction.amount
        }
    }
    
    var remainingAmount: Double {
        return amount - transactionTotal
    }
}
