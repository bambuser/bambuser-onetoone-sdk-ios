//
//  ProductViewController.swift
//  one-to-one-sdk-demo
//
//  Copyright © 2022 Bambuser. All rights reserved.
//

import UIKit
import BambuserLiveShoppingOnetoOne

class ProductViewController: UIViewController {

    private let product: Product!
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageView = UIImageView()
    private let dismissButton = UIButton()

    public init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        titleLabel.text = product.title
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 22.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        if let url = product?.imageUrl {
            ImageManager.shared.downloadImage(url: url) { [weak self] image in
                guard let image: UIImage = image else { return }
                if url == self?.product?.imageUrl {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }
        }

        descriptionLabel.text = product.description
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

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0),

            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0),

            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            descriptionLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5),
            descriptionLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -5),

            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            dismissButton.heightAnchor.constraint(equalToConstant: 30),
            dismissButton.widthAnchor.constraint(equalToConstant: 30),
            dismissButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -5)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // This ViewController is presented modally from InventoryViewController. Make sure we stay in front of it.
        MinimizedState.shared.bringToFront()
    }

    @objc func onTappedDismissButton() {
        dismiss(animated: true)
    }
}
