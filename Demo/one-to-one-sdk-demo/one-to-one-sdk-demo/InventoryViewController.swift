//
//  InventoryViewController.swift
//  one-to-one-sdk-demo
//
//  Copyright © 2022 Bambuser. All rights reserved.
//

import UIKit
import BambuserLiveShoppingOnetoOne

class InventoryViewController: UIViewController {

    let tableView = UITableView()
    let inventory = Inventory()
    public var inCart: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    public var inCall: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        MinimizedState.shared.agentView?.eventHandler = { [weak self] event in

            if case .productUpdateInCart(let cartStatus) = event {
                if cartStatus.quantity > 0 {
                    if self?.inCart.contains(cartStatus.sku) == false {
                        self?.inCart.append(cartStatus.sku)
                    }
                } else {
                    if let index = self?.inCart.firstIndex(of: cartStatus.sku) {
                        self?.inCart.remove(at: index)
                    }
                }
                if let productViewController = self?.presentedViewController as? ProductViewController {
                    productViewController.updateProductInCart(sku: cartStatus.sku, quantity: cartStatus.quantity)
                }
            } else if case .productRemovedFromCart(let sku) = event {
                if let index = self?.inCart.firstIndex(of: sku) {
                    self?.inCart.remove(at: index)
                }
                if let productViewController = self?.presentedViewController as? ProductViewController {
                    productViewController.updateProductInCart(sku: sku, quantity: 0 )
                }
            } else if case .productRemovedFromCall(let sku) = event {
                if let productViewController = self?.presentedViewController as? ProductViewController {
                    productViewController.updateProductInCall(sku: sku, inCall: false)
                }
                if let index = self?.inCall.firstIndex(of: sku) {
                    self?.inCall.remove(at: index)
                }
            } else if case .callStatusUpdate(let callStatus) = event {
                if let productViewController = self?.presentedViewController as? ProductViewController {
                    productViewController.updateCallStatus(status: callStatus)
                }
                if callStatus == .disconnecting {
                    self?.inCall = []
                    self?.inCart = []
                } else if callStatus == .disconnected {
                    guard MinimizedState.shared.isMinimized == false else { return }
                    guard let tabController = self?.tabBarController  else { return }
                    if let agentViewController = tabController.viewControllers?[0] as? AgentViewController {
                        guard let agentView = self?.agentViewInWindow() else { return }
                        self?.presentedViewController?.dismiss(animated: false)
                        agentViewController.restoreAgentView(agentView: agentView)
                    }
                }
            }
        }
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 150
    }
}

extension InventoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let products = inventory.products else { return 0 }
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        if let products = inventory.products {
            let product = products[indexPath.row]
            cell.product = product
            let sku = product.variations[product.defaultVariationIndex].sku
            cell.inCall = inCall.contains(sku)
            cell.inCart = inCart.contains(sku)
        }
        return cell
    }
}

extension InventoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let products = inventory.products else { return }
        guard indexPath.row < products.count else { return }
        let productViewController = ProductViewController(product: products[indexPath.row], presenter: self)
        self.present(productViewController, animated: true)
    }
}
