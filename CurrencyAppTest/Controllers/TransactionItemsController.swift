//
//  ProductDetailController.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 29.07.2025.
//

import UIKit

final class TransactionItemsController: UIViewController {
    
    private lazy var transactionsTableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(TwoLabelCell.self,
                           forCellReuseIdentifier: TwoLabelCell.identifier)
        return tableView
    }()
        
    private lazy var totalCountLabel = {
        let label = UILabel()
        
        ///Так можно писать color?
        label.backgroundColor =
        navigationController?
            .navigationBar
            .standardAppearance
            .backgroundColor
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        
        label.text = "Total: "
        return label
    }()
    
    private let vm: TransactionItemsVMProtocol
    
    init(transactionItemsVM: TransactionItemsVMProtocol) {
        vm = transactionItemsVM
        super.init(nibName: nil, bundle: nil)
        title = "Transactions for \(vm.productItem.sku)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(transactionsTableView)
        view.addSubview(totalCountLabel)

        transactionsTableView.tableHeaderView = UIView(frame: .zero)
        transactionsTableView.allowsSelection = false
        transactionsTableView.separatorInset = UIEdgeInsets(top: 0,
                                                        left: 0,
                                                        bottom: 0,
                                                        right: 0)
        
        NSLayoutConstraint.activate([
            totalCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            totalCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalCountLabel.heightAnchor.constraint(equalToConstant: 24),
            
            transactionsTableView.topAnchor.constraint(equalTo: totalCountLabel.bottomAnchor),
            transactionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            transactionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftMargin),
            transactionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension TransactionItemsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return vm.productItem.transactions.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TwoLabelCell.identifier,
                for: indexPath) as? TwoLabelCell
        else {
            return UITableViewCell()
        }
        
        let item = vm.productItem.transactions[indexPath.row]
        cell.configure(leftText: item.initialAmount,
                       rightText: item.amountGBP)
        
        return cell
    }
}
