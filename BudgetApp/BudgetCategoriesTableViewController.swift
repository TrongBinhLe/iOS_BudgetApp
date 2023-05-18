//
//  ViewController.swift
//  BudgetApp
//
//  Created by admin on 18/05/2023.
//

import UIKit
import CoreData

class BudgetCategoriesTableViewController: UIViewController {
    
    private var persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
    }


}

