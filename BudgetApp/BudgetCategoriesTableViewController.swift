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
        
        setupUI()
        
    }
    
    private func setupUI() {
        style()
        layout()
    }
    
    private func style() {
        
        let addBudgetCategoryButton = UIBarButtonItem(title: "Add Category", style: .done, target: self, action: #selector(showAddBudgetCategoty))
        
        self.navigationItem.rightBarButtonItem = addBudgetCategoryButton
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Budget"
    }
    
    private func layout() {
        
    }
    
    @objc func showAddBudgetCategoty(_ sender: UIButton) {
        let navController = UINavigationController(rootViewController: AddBudgetCategoryViewController(persistentContainer: persistentContainer))
        present(navController, animated: true)
    }


}

