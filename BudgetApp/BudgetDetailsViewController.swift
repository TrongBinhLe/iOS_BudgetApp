//
//  BudgetDetailsViewController.swift
//  BudgetApp
//
//  Created by admin on 19/05/2023.
//

import Foundation
import UIKit
import CoreData

class BudgetDetailsViewController: UIViewController {
    
    private var persistentContainer: NSPersistentContainer
    private var budgetCategory: BudgetCategory
    private var fetchResultsController: NSFetchedResultsController<Transaction>!
    
    let stackView = UIStackView()
    
    lazy var nameTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Transaction name"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    lazy var amountTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Transaction amount"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var saveTransactionButton: UIButton = {
        let config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.setTitle("Save transaction", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.text = ""
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = budgetCategory.amount.formatAsCurrency()
        return label
    }()
    
    lazy var transactionsTotalLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    init(budgetCategory: BudgetCategory, persistentContainer: NSPersistentContainer) {
        self.budgetCategory = budgetCategory
        self.persistentContainer = persistentContainer
        
        super.init(nibName: nil, bundle: nil)
        
        // create request based on selected budget category
        let request = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@", budgetCategory)
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        
        do {
           try fetchResultsController.performFetch()
        } catch {
            errorMessageLabel.text = "Unable to fetch transactions."
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        updateTransactionTotal()
    }
    
    private func style() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = budgetCategory.name
        
        //Stack View
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        //Save Transaction Button
        saveTransactionButton.addTarget(self, action: #selector(saveTransactionButtonPressed), for: .touchUpInside)
        
      
        
    }
    
    private func layout() {
        stackView.addArrangedSubview(amountLabel)
        stackView.setCustomSpacing(50, after: amountLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(amountTextField)
        stackView.addArrangedSubview(saveTransactionButton)
        stackView.addArrangedSubview(errorMessageLabel)
        stackView.addArrangedSubview(transactionsTotalLabel)
        stackView.addArrangedSubview(tableView)
        
        view.addSubview(stackView)
        
        nameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        amountTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        saveTransactionButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 600).isActive = true
        
    }
//    private var transactionTotal: Double {
//        let transactions = fetchResultsController.fetchedObjects ?? []
//        return transactions.reduce(0) { next, transaction in
//            next + transaction.amount
//        }
//    }
    
    private func updateTransactionTotal() {
        transactionsTotalLabel.text = budgetCategory.transactionTotal.formatAsCurrency()
    }
    
    private func isFormValid() -> Bool {
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return false
        }
        return !name.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreatorThan(0)
    }
    
    private func resetForm() {
        nameTextField.text = ""
        amountTextField.text = ""
        errorMessageLabel.text = ""
    }
    
    private func saveTransaction() {
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return
        }
        // Creating the transaction for budget
        let transaction = Transaction(context: persistentContainer.viewContext)
        transaction.name = name
        transaction.amount = Double(amount) ?? 0.0
        transaction.dateCreated = Date()
        
//        // Adding the transaction for budget --- Solution 1
//        budgetCategory.addToTransactions(transaction)
        // Solution 2
        transaction.category = budgetCategory
        
        do {
            try persistentContainer.viewContext.save()
            //reset form
            resetForm()
            tableView.reloadData()
        } catch {
            errorMessageLabel.text = "Unable to save transaction"
        }
        
    }
    
    private func deteleteTransaction(_ transaction: Transaction) {
        persistentContainer.viewContext.delete(transaction)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            errorMessageLabel.text = "Unable to delete transaction"
        }
    }
    
}

extension BudgetDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchResultsController.fetchedObjects ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath)
        
        let transaction = fetchResultsController.object(at: indexPath)
        // cell configuration
        var content = cell.defaultContentConfiguration()
        content.text = transaction.name
        content.secondaryText = transaction.amount.formatAsCurrency()
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}

extension BudgetDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let transaction = fetchResultsController.object(at: indexPath)
            deteleteTransaction(transaction)
        }
    }
}

extension BudgetDetailsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        updateTransactionTotal()
    }
}

// MARK: Action
extension BudgetDetailsViewController {
    @objc func saveTransactionButtonPressed(_ sender: UIButton) {
        if isFormValid() {
            saveTransaction()
        } else {
            errorMessageLabel.text = "Make sure name and amount is valid"
        }
    }
}
