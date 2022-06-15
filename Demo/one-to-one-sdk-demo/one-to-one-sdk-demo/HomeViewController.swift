//
//  HomeViewController.swift
//  one-to-one-sdk-demo
//
//  Copyright © 2022 Bambuser. All rights reserved.
//

import UIKit
import BambuserLiveShoppingOnetoOne

class HomeViewController: UIViewController {

    private let imageView = UIImageView()
    private let navigationButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        navigationButton.setTitle("Go to shop", for: .normal)
        navigationButton.setTitleColor(.black, for: .normal)
        navigationButton.layer.borderWidth = 2
        navigationButton.layer.borderColor = UIColor.black.cgColor
        navigationButton.translatesAutoresizingMaskIntoConstraints = false
        navigationButton.addTarget(self, action: #selector(onTappedNavigationButton), for: .touchUpInside)
        self.view.addSubview(navigationButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0),

            navigationButton.widthAnchor.constraint(equalToConstant: 220),
            navigationButton.heightAnchor.constraint(equalToConstant: 50),
            navigationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            navigationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MinimizedState.shared.registerRestoreAction { [weak self] agentView in
            print("restore from rootview")
            self?.navigationController?.pushViewController(MeetingViewController(view: agentView), animated: false)
        }
    }

    @objc func onTappedNavigationButton() {
        navigationController?.pushViewController(MeetingViewController(), animated: true)
    }

}
