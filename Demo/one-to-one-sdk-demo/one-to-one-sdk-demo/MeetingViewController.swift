//
//  MeetingViewController.swift
//  one-to-one-sdk-demo
//
//  Copyright © 2022 Bambuser. All rights reserved.
//

import UIKit
import BambuserLiveShoppingOnetoOne

class MeetingViewController: UITabBarController, UITabBarControllerDelegate {

    private var agentView: LiveShoppingAgentView?
    private var inventoryViewController: InventoryViewController!
    private var agentViewController: AgentViewController!

    public init(view: LiveShoppingAgentView? = nil) {
        self.agentView = view
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

        agentViewController = AgentViewController(view: self.agentView)
        self.agentView = nil
        let agentTabBarItem = UITabBarItem(title: "Agent", image: UIImage(systemName: "phone"), selectedImage: UIImage(systemName: "phone.fill"))
        agentViewController.tabBarItem = agentTabBarItem

        inventoryViewController = InventoryViewController()
        let productTabBarItem = UITabBarItem(title: "Products", image: UIImage(systemName: "folder"), selectedImage: UIImage(systemName: "folder.fill"))
        inventoryViewController.tabBarItem = productTabBarItem

        self.viewControllers = [agentViewController!, inventoryViewController!]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MinimizedState.shared.registerRestoreAction { [weak self] agentView in
            // If agent is in the InventoryViewController during a call, maximize it in the UIWindow
            if agentView.callSessionStatus == .running && self?.selectedIndex == 1 {
                print("Restore back to UIWindow during a call")
            } else {
                // This handles restore back to fullscreen while in the MeetingViewController
                self?.inventoryViewController?.presentedViewController?.dismiss(animated: false)
                self?.agentViewController?.restoreAgentView(agentView: agentView)
            }
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let agentView: LiveShoppingAgentView?
        if let view = MinimizedState.shared.agentView {
            agentView = view
        } else {
            agentView = agentViewController?.agentView
        }
        agentView?.getProductsInCall(completion: { [weak self] result in
            switch result {
            case .success(let skus):
                print("getProductsInCall has returned: \(String(describing: skus))")
                if let skus = skus {
                    self?.inventoryViewController?.inCall = skus
                }
            case.failure(let error):
                print("isProductInCall error: \(String(describing: error))")
                if error == .noActiveCall {
                    self?.inventoryViewController?.inCall = []
                }
            }
        })

        agentView?.getProductsInCart(completion: { [weak self] result in
            switch result {
            case .success(let skus):
                print("getProductsInCall has returned: \(String(describing: skus))")
                if let skus = skus {
                    self?.inventoryViewController?.inCart = skus
                }
            case.failure(let error):
                print("isProductInCall error: \(String(describing: error))")
                if error == .noActiveCall {
                    self?.inventoryViewController?.inCart = []
                }
            }
        })
    }
}
