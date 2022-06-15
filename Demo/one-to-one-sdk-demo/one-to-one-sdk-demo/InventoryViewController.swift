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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
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
        return inventory.products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        cell.product = inventory.products[indexPath.row]
        return cell
    }
}

extension InventoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productViewController = ProductViewController(product: inventory.products[indexPath.row])
        self.present(productViewController, animated: true)
    }
}
