//
//  ViewController.swift
//  BudgetApp
//
//  Created by admin on 18/05/2023.
//

import UIKit
import CoreData

class BudgetCategoriesTableViewController: UITableViewController {
    
    private var persistentContainer: NSPersistentContainer
    private var fetchResultsController: NSFetchedResultsController<BudgetCategory>!
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
        
        let request = BudgetCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        
        do {
            try fetchResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        
        //register cell
        tableView.register(BudgetTableViewCell.self, forCellReuseIdentifier: "BudgetTableViewCell")
        
    }
    
    private func setupUI() {
        style()
        layout()
    }
    
    @objc func showAddBudgetCategoty(_ sender: UIButton) {
        let navController = UINavigationController(rootViewController: AddBudgetCategoryViewController(persistentContainer: persistentContainer))
        present(navController, animated: true)
    }
    
    private func style() {
        
        let addBudgetCategoryButton = UIBarButtonItem(title: "Add Category", style: .done, target: self, action: #selector(showAddBudgetCategoty))
        
        self.navigationItem.rightBarButtonItem = addBudgetCategoryButton
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Budget"
    }
    
    private func layout() {
        
    }
    
    private func deleteBudgetCategory(_ budgetCategory: BudgetCategory) {
        persistentContainer.viewContext.delete(budgetCategory)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            // Alert error
//            let alert = UIAlertController(title: "Error", message: "Unable to delete budget category", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            present(alert, animated: true)
            showAlert(title: "Error", message: "Unable to delete budget category")
        }
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchResultsController.fetchedObjects ?? []).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetTableViewCell", for: indexPath) as? BudgetTableViewCell else {
            return BudgetTableViewCell(style: .default, reuseIdentifier: "BudgetTableViewCell")
        }
        
        cell.accessoryType = .disclosureIndicator
        
        let budgetCategory = fetchResultsController.object(at: indexPath)
        cell.configure(budgetCategory)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let budgetCategory = fetchResultsController.object(at: indexPath)
        // perform navigation
        navigationController?.pushViewController(BudgetDetailsViewController(budgetCategory: budgetCategory, persistentContainer: persistentContainer), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let budgetCategory = fetchResultsController.object(at: indexPath)
            deleteBudgetCategory(budgetCategory)
        }
    }
}



extension BudgetCategoriesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
