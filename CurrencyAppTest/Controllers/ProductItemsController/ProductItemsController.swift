//
//  ProductItemsController.swift
//  Test
//
//  Created by Malik Timurkaev on 30.06.2025.
//


import UIKit
import Combine

final class ProductItemsController: UIViewController {
    
    private lazy var productsTableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
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
    
    private let vm: ProductItemsVMProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(productItemsVM: ProductItemsVMProtocol) {
        vm = productItemsVM
        super.init(nibName: nil, bundle: nil)
    }
    
    ///Это нормально пробрасывать fatalError в таком случае?
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Products"
        setupUI()
        bindViewModel()
        vm.fetchProductItems()
    }
    
    private func bindViewModel() {
        vm.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                
                guard let self else { return }
                
                switch state {
                    
                case .loading:
                    blurLoaderView.showLoader()
                case .loaded:
                    productsTableView.reloadData()
                    blurLoaderView.hideLoader()
                case .error(let error):
                    showAlert(with: error)
                    blurLoaderView.hideLoader()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showAlert(with error: Error) {
        let title = "Something went wrong"
        let alert = UIAlertController(
            title: title,
            message: error.localizedDescription,
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel)
        
        let repeatAction = UIAlertAction(
            title: "Repeat",
            style: .default) { [weak self] _ in
                
                self?.vm.fetchProductItems()
            }
        
        alert.addActions([cancelAction, repeatAction])
        present(alert, animated: true)
    }
    
    private func setupUI() {
        view.addSubview(productsTableView)
        view.addSubview(blurLoaderView)
        
        productsTableView.separatorInset = UIEdgeInsets(top: 0,
                                                        left: 0,
                                                        bottom: 0,
                                                        right: 0)
        
        NSLayoutConstraint.activate([
            productsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            productsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            productsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            blurLoaderView.topAnchor.constraint(equalTo: view.topAnchor),
            blurLoaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurLoaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurLoaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ProductItemsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return vm.productItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        ///Можно ли писать с такими пробелами у guard и else?
        ///Не является ли признаком плохого опыта?
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TwoLabelCell.identifier,
                for: indexPath) as? TwoLabelCell
        else {
            return UITableViewCell()
        }
        
        cell.accessoryType = .disclosureIndicator
        
        if let item = vm.productItems[safe: indexPath.row] {
            let count = "\(item.transactions.count) transactions"
            cell.configure(leftText: item.sku,
                           rightText: count)
        }
        
        return cell
    }
}

extension ProductItemsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
