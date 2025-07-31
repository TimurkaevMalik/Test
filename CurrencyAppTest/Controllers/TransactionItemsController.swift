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
        
#warning("Так можно писать color? Речь об отступах для читаемости")
        label.backgroundColor =
        navigationController?
            .navigationBar
            .standardAppearance
            .backgroundColor
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        
        let symbol = vm.productItem.total.currency
        let amount = vm.productItem.total.amount
        
        label.text = "Total: " + symbol + amount
        return label
    }()
    
    private let vm: TransactionItemsVMProtocol
    
    init(transactionItemsVM: TransactionItemsVMProtocol) {
        vm = transactionItemsVM
        super.init(nibName: nil, bundle: nil)
        title = "Transactions for \(vm.productItem.sku)"
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
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
        
        let leftText = "\(item.initial.currency)" + "\(item.initial.amount)"
        let rightText = "\(item.converted.currency)" + "\(item.converted.amount)"
        
        cell.configure(leftText: leftText, rightText: rightText)
        
        return cell
    }
}

private extension TransactionItemsController {
    func setupUI() {
        view.addSubview(transactionsTableView)
        view.addSubview(totalCountLabel)

        transactionsTableView.tableHeaderView = UIView(frame: .zero)
        transactionsTableView.allowsSelection = false
        transactionsTableView.separatorInset = UIEdgeInsets(top: 0,
                                                        left: 0,
                                                        bottom: 0,
                                                        right: 0)
        
        view.attachOnTopSafeArea(subview: totalCountLabel)
        
        NSLayoutConstraint.activate([
            totalCountLabel.heightAnchor.constraint(equalToConstant: 24),
            
            transactionsTableView.topAnchor.constraint(equalTo: totalCountLabel.bottomAnchor),
            transactionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            transactionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftMargin),
            transactionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
