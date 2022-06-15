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
    private var inventoryViewController: InventoryViewController?
    private var agentViewController: AgentViewController?

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
        agentViewController!.tabBarItem = agentTabBarItem

        inventoryViewController = InventoryViewController()
        let productTabBarItem = UITabBarItem(title: "Products", image: UIImage(systemName: "folder"), selectedImage: UIImage(systemName: "folder.fill"))
        inventoryViewController!.tabBarItem = productTabBarItem

        self.viewControllers = [agentViewController!, inventoryViewController!]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MinimizedState.shared.registerRestoreAction { [weak self] agentView in
            // This handles restore back to fullscreen while in the MeetingViewController
            print("Restore back as a subview")
            self?.inventoryViewController?.presentedViewController?.dismiss(animated: false)
            if AgentViewController.agentInWindow == false {
                self?.agentViewController?.restoreAgentView(agentView: agentView)
            }
            self?.selectedIndex = 0
        }
    }
}
