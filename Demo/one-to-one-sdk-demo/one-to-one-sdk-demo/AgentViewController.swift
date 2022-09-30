//
//  AgentViewController.swift
//  one-to-one-sdk-demo
//
//  Copyright © 2022 Bambuser. All rights reserved.
//

import UIKit
import BambuserLiveShoppingOnetoOne

class AgentViewController: UIViewController {

    private let label = UILabel()
    private let startButton = UIButton()
    private let imageView = UIImageView()
    private let bookingTextField = UITextField()
    private var tapGestureRecognizer: UITapGestureRecognizer!

    var agentView: LiveShoppingAgentView?
    private let region: Region = // set region .global or .eu
    private let organisationId = "" // your organisation
    private let connectId = "" // Add your meeting / booking id

    public init(view: LiveShoppingAgentView? = nil) {
        self.agentView = view
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        bookingTextField.translatesAutoresizingMaskIntoConstraints = false
        bookingTextField.placeholder = "bookingId"
        bookingTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: bookingTextField.frame.height))
        bookingTextField.delegate = self
        bookingTextField.leftViewMode = .always
        bookingTextField.layer.borderWidth = 2
        bookingTextField.layer.borderColor = UIColor.black.cgColor
        bookingTextField.text = connectId
        view.addSubview(bookingTextField)

        let bookingLabel = UILabel()
        bookingLabel.text = "Booking Id:"
        bookingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bookingLabel)

        if MinimizedState.shared.isMinimized == false {
            startButton.setTitle("Open agent tool", for: .normal)
        } else {
            startButton.setTitle("Close agent tool", for: .normal)
        }
        startButton.setTitleColor(.black, for: .normal)
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(onTappedStartButton), for: .touchUpInside)
        view.addSubview(startButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0),

            bookingTextField.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -30),
            bookingTextField.heightAnchor.constraint(equalToConstant: 40),
            bookingTextField.widthAnchor.constraint(equalToConstant: 250),
            bookingTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            bookingLabel.bottomAnchor.constraint(equalTo: bookingTextField.topAnchor, constant: -5),
            bookingLabel.heightAnchor.constraint(equalToConstant: 40),
            bookingLabel.widthAnchor.constraint(equalToConstant: 100),
            bookingLabel.leftAnchor.constraint(equalTo: bookingTextField.leftAnchor),

            startButton.widthAnchor.constraint(equalToConstant: 220),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        NotificationCenter.default.addObserver(self, selector: #selector(AgentViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AgentViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        guard MinimizedState.shared.isMinimized == false else { return }
        guard let agentView = self.agentView else { return }
        // This path is taken when restoring agentView when in the HomeViewController
        restoreAgentView(agentView: agentView)
    }

    override func viewDidAppear(_ animated: Bool) {
        guard let agentView = self.agentViewInWindow() else { return }
        agentView.eventHandler = { [weak self] event in
            if case .callStatusUpdate(let callStatus) = event {
                if callStatus == .disconnected {
                    if MinimizedState.shared.isMinimized == false {
                        self?.restoreAgentView(agentView: agentView)
                    }
                }
            }
        }
    }

    public func restoreAgentView(agentView: LiveShoppingAgentView) {
        print("Restore back as a subview")
        self.agentView = agentView
        view.addSubview(agentView)
        self.tabBarController?.selectedIndex = 0
        agentView.eventHandler = { [weak self] event in
            if event == .didLoad {
                self?.startButton.setTitle("Close agent tool", for: .normal)
            }
            print("Event: \(event)")
        }
        setupAgentViewConstraints()
        startButton.setTitle("Close agent tool", for: .normal)
    }

    @objc func onTappedStartButton() {
        if MinimizedState.shared.isMinimized || agentView != nil {
            MinimizedState.shared.remove()
            startButton.setTitle("Open agent tool", for: .normal)
            agentView = nil
            return
        }

        createAgentView()
        guard let agentView = self.agentView else { return }
        view.addSubview(agentView)
        setupAgentViewConstraints()
        agentView.loadBooking(connectId: bookingTextField.text ?? connectId)
        startButton.setTitle("Loading...", for: .normal)
    }

    func createAgentView() {
        agentView = LiveShoppingAgentView(region: region, organisationId: organisationId)
        agentView?.tapToMaximize = true
        agentView?.minimizedSize = CGSize(width: 180, height: 320)
        agentView?.minimizedOrigin = .topLeft
        agentView?.eventHandler = { [weak self] event in
            if event == .didLoad {
                self?.startButton.setTitle("Close agent tool", for: .normal)
            }
            print("Event: \(event)")
        }
    }

    func setupAgentViewConstraints() {
        guard let agentView = self.agentView else { return }
        agentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            agentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            agentView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            agentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            agentView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0)
        ])
    }
}

extension AgentViewController {

    @objc func keyboardWillShow(notification: NSNotification) {
        guard bookingTextField.isFirstResponder == true else { return }
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue

        guard self.view.frame.origin.y == 0 else { return }
        self.view.frame.origin.y -= keyboardFrame.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard bookingTextField.isFirstResponder == true else { return }
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue

        guard self.view.frame.origin.y != 0 else { return }
        self.view.frame.origin.y += keyboardFrame.height
    }

    @objc func tapHandler(_ sender: UITapGestureRecognizer) {
        bookingTextField.resignFirstResponder()
    }
}

extension AgentViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard MinimizedState.shared.isMinimized == false else { return false }
        guard let agentView = self.agentView else { return true }
        return !agentView.isLoaded
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        startButton.isEnabled = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let textLength = textField.text?.count ?? 0
        startButton.isEnabled =  textLength > 1 // verify with regex
        view.removeGestureRecognizer(tapGestureRecognizer)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
