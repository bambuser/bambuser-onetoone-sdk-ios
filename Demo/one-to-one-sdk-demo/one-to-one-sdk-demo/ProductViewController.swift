//
//  ProductViewController.swift
//  one-to-one-sdk-demo
//
//  Copyright © 2022 Bambuser. All rights reserved.
//

import UIKit
import BambuserLiveShoppingOnetoOne

class ProductViewController: UIViewController {

    public let product: Product?
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageView = UIImageView()
    private let dismissButton = UIButton()
    private let addToCallButton = UIButton()
    private let removeFromCallButton = UIButton()
    private let removeFromCartButton = UIButton()
    private let increaseCartButton = UIButton(type: .system)
    private let decreaseCartButton = UIButton(type: .system)
    private let quantityLabel = UILabel()
    private let callTagImageView = UIImageView()
    private let cartTagImageView = UIImageView()
    private weak var presenter: UIViewController?

    public init(product: Product, presenter: UIViewController) {
        self.presenter = presenter
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        titleLabel.text = product?.name
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 22.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        if let url = product?.variations[0].imageUrls[0] {
            ImageManager.shared.downloadImage(url: url) { [weak self] image in
                guard let image: UIImage = image else { return }
                if url == self?.product?.variations[0].imageUrls[0] {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }
        }
        descriptionLabel.text = product?.description
        descriptionLabel.textColor = .darkGray
        descriptionLabel.font = descriptionLabel.font.withSize(16)
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.sizeToFit()
        view.addSubview(descriptionLabel)

        dismissButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.addTarget(self, action: #selector(onTappedDismissButton), for: .touchUpInside)
        view.addSubview(dismissButton)

        callTagImageView.image = UIImage(systemName: "phone")
        callTagImageView.tintColor = .darkGray
        callTagImageView.isHidden = true
        callTagImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(callTagImageView)

        cartTagImageView.image = UIImage(systemName: "cart")
        cartTagImageView.tintColor = .darkGray
        cartTagImageView.isHidden = true
        cartTagImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cartTagImageView)

        addToCallButton.setTitle("Add to call", for: .normal)
        addToCallButton.setTitleColor(.black, for: .normal)
        addToCallButton.layer.borderWidth = 2
        addToCallButton.layer.borderColor = UIColor.black.cgColor
        addToCallButton.backgroundColor = .white
        addToCallButton.titleLabel?.font = .systemFont(ofSize: 12)
        addToCallButton.translatesAutoresizingMaskIntoConstraints = false
        addToCallButton.addTarget(self, action: #selector(onTappedAddToCallButton), for: .touchUpInside)
        self.view.addSubview(addToCallButton)

        removeFromCallButton.setTitle("Remove from call", for: .normal)
        removeFromCallButton.setTitleColor(.black, for: .normal)
        removeFromCallButton.layer.borderWidth = 2
        removeFromCallButton.layer.borderColor = UIColor.black.cgColor
        removeFromCallButton.backgroundColor = .white
        removeFromCallButton.titleLabel?.font = .systemFont(ofSize: 12)
        removeFromCallButton.translatesAutoresizingMaskIntoConstraints = false
        removeFromCallButton.isHidden = true
        removeFromCallButton.addTarget(self, action: #selector(onTappedRemoveFromCallButton), for: .touchUpInside)
        self.view.addSubview(removeFromCallButton)

        decreaseCartButton.setTitle("-", for: .normal)
        decreaseCartButton.setTitleColor(.black, for: .normal)
        decreaseCartButton.backgroundColor = .lightGray
        decreaseCartButton.layer.cornerRadius = 12
        decreaseCartButton.titleLabel?.font = .systemFont(ofSize: 12)
        decreaseCartButton.titleLabel?.textAlignment = .center
        decreaseCartButton.translatesAutoresizingMaskIntoConstraints = false
        decreaseCartButton.addTarget(self, action: #selector(onTappedDecreaseCartButton), for: .touchUpInside)
        decreaseCartButton.isHidden = true
        self.view.addSubview(decreaseCartButton)

        increaseCartButton.setTitle("+", for: .normal)
        increaseCartButton.setTitleColor(.black, for: .normal)
        increaseCartButton.backgroundColor = .lightGray
        increaseCartButton.layer.cornerRadius = 12
        increaseCartButton.titleLabel?.font = .systemFont(ofSize: 12)
        increaseCartButton.titleLabel?.textAlignment = .center
        increaseCartButton.translatesAutoresizingMaskIntoConstraints = false
        increaseCartButton.addTarget(self, action: #selector(onTappedAddToCartButton), for: .touchUpInside)
        increaseCartButton.isHidden = true
        self.view.addSubview(increaseCartButton)

        quantityLabel.text = "0"
        quantityLabel.textColor = .black
        quantityLabel.font = .boldSystemFont(ofSize: 16.0)
        quantityLabel.textAlignment = .center
        quantityLabel.numberOfLines = 0
        quantityLabel.lineBreakMode = .byWordWrapping
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.sizeToFit()
        quantityLabel.isHidden = true
        view.addSubview(quantityLabel)

        removeFromCartButton.setImage(UIImage(systemName: "trash"), for: .normal)
        removeFromCartButton.translatesAutoresizingMaskIntoConstraints = false
        removeFromCartButton.isHidden = true
        removeFromCartButton.addTarget(self, action: #selector(onTappedRemoveFromCartButton), for: .touchUpInside)
        self.view.addSubview(removeFromCartButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0),

            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0),

            callTagImageView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 6),
            callTagImageView.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 6),
            callTagImageView.heightAnchor.constraint(equalToConstant: 25),
            callTagImageView.widthAnchor.constraint(equalToConstant: 25),

            cartTagImageView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 6),
            cartTagImageView.leftAnchor.constraint(equalTo: callTagImageView.rightAnchor, constant: 5),
            cartTagImageView.heightAnchor.constraint(equalToConstant: 25),
            cartTagImageView.widthAnchor.constraint(equalToConstant: 25),

            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            descriptionLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5),
            descriptionLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -5),

            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            dismissButton.heightAnchor.constraint(equalToConstant: 30),
            dismissButton.widthAnchor.constraint(equalToConstant: 30),
            dismissButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -5),

            addToCallButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            addToCallButton.heightAnchor.constraint(equalToConstant: 30),
            addToCallButton.widthAnchor.constraint(equalToConstant: 110),
            addToCallButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5),

            removeFromCallButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            removeFromCallButton.heightAnchor.constraint(equalToConstant: 30),
            removeFromCallButton.widthAnchor.constraint(equalToConstant: 110),
            removeFromCallButton.leftAnchor.constraint(equalTo: addToCallButton.rightAnchor, constant: 5),

            decreaseCartButton.topAnchor.constraint(equalTo: addToCallButton.bottomAnchor, constant: 10),
            decreaseCartButton.heightAnchor.constraint(equalToConstant: 26),
            decreaseCartButton.widthAnchor.constraint(equalToConstant: 26),
            decreaseCartButton.leftAnchor.constraint(equalTo: addToCallButton.leftAnchor, constant: 5),

            quantityLabel.topAnchor.constraint(equalTo: addToCallButton.bottomAnchor, constant: 10),
            quantityLabel.heightAnchor.constraint(equalToConstant: 30),
            quantityLabel.widthAnchor.constraint(equalToConstant: 30),
            quantityLabel.leftAnchor.constraint(equalTo: decreaseCartButton.rightAnchor, constant: 5),

            increaseCartButton.topAnchor.constraint(equalTo: addToCallButton.bottomAnchor, constant: 10),
            increaseCartButton.heightAnchor.constraint(equalToConstant: 26),
            increaseCartButton.widthAnchor.constraint(equalToConstant: 26),
            increaseCartButton.leftAnchor.constraint(equalTo: quantityLabel.rightAnchor, constant: 5),
            
            removeFromCartButton.topAnchor.constraint(equalTo: removeFromCallButton.bottomAnchor, constant: 5),
            removeFromCartButton.heightAnchor.constraint(equalToConstant: 30),
            removeFromCartButton.widthAnchor.constraint(equalToConstant: 110),
            removeFromCartButton.leftAnchor.constraint(equalTo: increaseCartButton.rightAnchor, constant: 5),

        ])

        addToCallButton.isHidden = !(MinimizedState.shared.agentView?.callSessionStatus == .running)

        if let product = product {
            // NOTE! We are working with variantion skus here!
            let defaultvariationSku = product.variations[product.defaultVariationIndex].sku

            MinimizedState.shared.isProductInCall(sku: defaultvariationSku, completion: { [weak self] result in
                switch result {
                case .success(let value):
                    print("isProductInCall has returned: \(String(describing: value))")
                    if let inCall = value {
                        self?.updateProductInCall(sku: defaultvariationSku, inCall: inCall)
                    }
                case.failure(let error):
                    print("isProductInCall error: \(String(describing: error))")
                    if error == .noActiveCall {
                        self?.updateProductInCall(sku: defaultvariationSku, inCall: false)
                    }
                }
            })

            MinimizedState.shared.getCartStatus(completion: { [weak self] result in
                switch result {
                case .success(let cart):
                    if let cart = cart {
                        if let quantity = cart[defaultvariationSku] {
                            self?.updateProductInCart(sku: defaultvariationSku , quantity: quantity)
                        }
                    }
                case .failure(let error):
                    print("getCartStatus error: \(String(describing: error))")
                    if error == .noActiveCall {
                        self?.updateProductInCart(sku: defaultvariationSku , quantity: 0)
                    }
                }
            })
        }
    }

    public func updateCallStatus(status: CallSessionStatus) {
        if status == .running {
            addToCallButton.isHidden = false
        } else if status == .disconnecting {
            addToCallButton.isHidden = true
            if let product = product {
                let sku = product.variations[product.defaultVariationIndex].sku
                updateProductInCall(sku: sku, inCall: false)
                updateProductInCart(sku: sku, quantity: 0)
            }
        }
    }

    public func updateProductInCall(sku: String, inCall: Bool) {
        guard let product = self.product else { return }
        // NOTE! We are working with variantion skus here!
        let defaultvariationSku = product.variations[product.defaultVariationIndex].sku
        guard sku == defaultvariationSku else { return }

        self.callTagImageView.isHidden = !inCall
        self.removeFromCallButton.isHidden = !inCall

        self.increaseCartButton.isHidden = !inCall
        self.decreaseCartButton.isHidden = !inCall
        self.quantityLabel.isHidden = !inCall
    }

    public func updateProductInCart(sku: String, quantity: Int) {
        guard let product = self.product else { return }
        // NOTE! We are working with variantion skus here!
        let defaultvariationSku = product.variations[product.defaultVariationIndex].sku
        guard sku == defaultvariationSku else { return }

        self.quantityLabel.text = String(quantity)
        let hidden = quantity <= 0
        self.cartTagImageView.isHidden = hidden
        self.removeFromCartButton.isHidden = hidden
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // This ViewController is presented modally from InventoryViewController. Make sure we stay in front of it.
        MinimizedState.shared.bringToFront()
    }

    @objc func onTappedAddToCallButton() {
        guard let product = self.product else { return }

        MinimizedState.shared.addProductToCall(product: product, completion: { [weak self] error in
            if error == nil {
                print("addProductToCall returned")
                let sku = product.variations[product.defaultVariationIndex].sku
                self?.updateProductInCall(sku: sku, inCall: true)
                if let inventoryController = self?.presenter as? InventoryViewController {
                    inventoryController.inCall.append(sku)
                    inventoryController.tableView.reloadData()
                }
            } else {
                print("addProductToCall error: \(String(describing: error))")
            }
        })
    }

    @objc func onTappedRemoveFromCallButton() {
        guard let product = self.product else { return }
        let defaultvariationSku = product.variations[product.defaultVariationIndex].sku

        MinimizedState.shared.removeProductInCall(sku: defaultvariationSku, completion: { error in
            if error == nil {
                print("removeProductInCall returned")
            } else {
                print("removeProductInCall error: \(String(describing: error))")
            }
        })
    }

    @objc func onTappedAddToCartButton() {
        guard let product = self.product else { return }
        let defaultvariationSku = product.variations[product.defaultVariationIndex].sku

        MinimizedState.shared.addProductToCart(sku: defaultvariationSku, completion: { error in
            if error == nil {
                print("addProductToCart returned")
            } else {
                print("addProductToCart error: \(String(describing: error))")
            }
        })
    }

    @objc func onTappedDecreaseCartButton() {
        guard let product = self.product else { return }
        let defaultvariationSku = product.variations[product.defaultVariationIndex].sku

        MinimizedState.shared.agentView?.decrementProductInCart(sku: defaultvariationSku, completion: { error in
            if error == nil {
                print("decrementProductInCart returned")
            } else {
                print("decrementProductInCart error: \(String(describing: error))")
            }
        })
    }

    @objc func onTappedRemoveFromCartButton() {
        guard let product = self.product else { return }
        let defaultvariationSku = product.variations[product.defaultVariationIndex].sku

        MinimizedState.shared.removeProductInCart(sku: defaultvariationSku, completion: { error in
            if error == nil {
                print("removeProductInCart returned")
            } else {
                print("removeProductInCart error: \(String(describing: error))")
            }
        })
    }

    @objc func onTappedDismissButton() {
        dismiss(animated: true)
    }
}
