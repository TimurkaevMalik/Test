//
//  ProductCell.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 28.07.2025.
//

import UIKit

final class ProductCell: UITableViewCell {
    ///Нормально или устанавливать статичный identifier?
    static let identifier = "ProductItemCell"
    
    private let skuLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let transactionsCountLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func configure(sku: String, transactionsCount: Int) {
        skuLabel.text = sku
        transactionsCountLabel.text = String(transactionsCount)
    }
    
    private func setupUI() {
        contentView.addSubview(skuLabel)
        contentView.addSubview(transactionsCountLabel)
        
        NSLayoutConstraint.activate([
            skuLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            skuLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            transactionsCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            transactionsCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            skuLabel.trailingAnchor.constraint(lessThanOrEqualTo: transactionsCountLabel.leadingAnchor, constant: -12)
        ])
    }
}
