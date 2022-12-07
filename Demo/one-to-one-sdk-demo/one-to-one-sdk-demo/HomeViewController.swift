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
    private let loginButton = UIButton()
    private let loggedInLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MinimizedState.shared.registerRestoreAction { [weak self] agentView in
            self?.navigationController?.pushViewController(MeetingViewController(view: agentView), animated: false)
        }

        updateLoginState()
    }

    private func setupUI() {
        setupImageView()
        setupNavigationButton()
        setupLoginButton()
        setupLoggedInLabel()
    }

    private func setupImageView() {
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0),
        ])
    }

    private func setupNavigationButton() {
        navigationButton.setTitle("Go to shop", for: .normal)
        navigationButton.setTitleColor(.black, for: .normal)
        navigationButton.layer.borderWidth = 2
        navigationButton.layer.borderColor = UIColor.black.cgColor
        navigationButton.translatesAutoresizingMaskIntoConstraints = false
        navigationButton.addTarget(self, action: #selector(onTappedNavigationButton), for: .touchUpInside)
        self.view.addSubview(navigationButton)

        NSLayoutConstraint.activate([
            navigationButton.widthAnchor.constraint(equalToConstant: 220),
            navigationButton.heightAnchor.constraint(equalToConstant: 50),
            navigationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            navigationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }

    private func setupLoginButton() {
        loginButton.setTitle("Login with Okta", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.black.cgColor
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(onTappedLoginButton), for: .touchUpInside)
        self.view.addSubview(loginButton)

        NSLayoutConstraint.activate([
            loginButton.widthAnchor.constraint(equalToConstant: 220),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: navigationButton.topAnchor, constant: -20)
        ])
    }

    private func setupLoggedInLabel() {
        loggedInLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loggedInLabel)

        loggedInLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        loggedInLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

    @objc func onTappedNavigationButton() {
        navigationController?.pushViewController(MeetingViewController(), animated: true)
    }

    func updateLoginState() {
        self.loginButton.isHidden = OktaLoginUtility.shared.credential != nil
        self.loggedInLabel.text = OktaLoginUtility.shared.credential?.token.idToken?.email
    }

    @objc func onTappedLoginButton() {
        Task {
            do {
                try await OktaLoginUtility.shared.login(anchor: view.window)
                updateLoginState()
            } catch {
                updateLoginState()
                loggedInLabel.text = error.localizedDescription
            }
        }
    }

}

extension UIViewController {
    /**
     Easy acces to LiveShoppingAgentView while in UIWindow
     */
    func agentViewInWindow() -> LiveShoppingAgentView? {
       return self.view.window?.subviews.first(where: { $0 is LiveShoppingAgentView }) as? LiveShoppingAgentView
    }
}
