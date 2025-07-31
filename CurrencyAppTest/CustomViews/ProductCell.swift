//
//  ProductCell.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 28.07.2025.
//

import UIKit

final class TwoLabelCell: UITableViewCell {
    
#warning("Нормально или устанавливать статичный identifier?")
    static let identifier = "TwoLabelCell"
    
    private let leftLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let rightLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16, weight: .regular)
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
    
    func configure(leftText: String, rightText: String) {
        leftLabel.text = leftText
        rightLabel.text = rightText
    }
    
    private func setupUI() {
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        
        NSLayoutConstraint.activate([
            leftLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            rightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            leftLabel.trailingAnchor.constraint(lessThanOrEqualTo: rightLabel.leadingAnchor, constant: -12)
        ])
    }
}
