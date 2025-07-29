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
    
    private lazy var blurLoaderView = {
        let loader = BlurLoaderView(with: .dark)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.isHidden = true
        return loader
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
        view.addSubview(blurLoaderView)
        
        transactionsTableView.allowsSelection = false
        transactionsTableView.separatorInset = UIEdgeInsets(top: 0,
                                                        left: 0,
                                                        bottom: 0,
                                                        right: 0)
        
        NSLayoutConstraint.activate([
            transactionsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            transactionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            transactionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            transactionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            blurLoaderView.topAnchor.constraint(equalTo: view.topAnchor),
            blurLoaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurLoaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurLoaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
