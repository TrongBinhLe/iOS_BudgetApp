//
//  BudgetCategoryTableViewCell.swift
//  BudgetApp
//
//  Created by admin on 31/05/2023.
//

import Foundation
import UIKit
import SwiftUI

class BudgetTableViewCell: UITableViewCell {
    
    let stackView = UIStackView()
    let vStackView = UIStackView()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var remainingLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.alpha = 0.5
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        styleUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ budgetCategory: BudgetCategory) {
        nameLabel.text = budgetCategory.name
        amountLabel.text = budgetCategory.amount.formatAsCurrency()
        remainingLabel.text = "Remaining: $50"
    }
    
    private func styleUI() {
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 44)
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        vStackView.axis = .vertical
        vStackView.alignment = .trailing
        vStackView.addArrangedSubview(amountLabel)
        vStackView.addArrangedSubview(remainingLabel)
        
    }
    
    private func layout() {
    
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(vStackView)
        
        self.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
    }
}

struct BudgetTableViewCellRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        BudgetTableViewCell(style: .default, reuseIdentifier: "BudgetTableViewCell")
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct BudgetTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        BudgetTableViewCellRepresentable()
    }
}
