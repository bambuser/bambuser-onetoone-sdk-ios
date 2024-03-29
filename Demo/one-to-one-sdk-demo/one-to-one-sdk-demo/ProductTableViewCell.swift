//
//  ProductTableViewCell.swift
//  one-to-one-sdk-demo
//
//  Copyright © 2022 Bambuser. All rights reserved.
//

import UIKit
import BambuserLiveShoppingOnetoOne

class ProductTableViewCell: UITableViewCell {

    var product: Product? {
        didSet {
            titleLabel.text = product?.name
            descriptionLabel.text = product?.description
            descriptionLabel.sizeToFit()

            guard let url = product?.variations[0].imageUrls[0] else { return }
            ImageManager.shared.downloadImage(url: url) { [weak self] image in
                guard let image: UIImage = image else { return }
                if url == self?.product?.variations[0].imageUrls[0] {
                    DispatchQueue.main.async {
                        self?.productImage.image = image
                    }
                }
            }
        }
    }

    var inCall: Bool = false {
        didSet {
            callTagImageView.isHidden = !inCall
        }
    }

    var inCart: Bool = false {
        didSet {
            cartTagImageView.isHidden = !inCart
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let callTagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "phone")
        imageView.tintColor = .darkGray
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let cartTagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cart")
        imageView.tintColor = .darkGray
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        addSubview(productImage)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(callTagImageView)
        addSubview(cartTagImageView)

        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            productImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            productImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            productImage.widthAnchor.constraint(equalToConstant: 80),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.leftAnchor.constraint(equalTo: productImage.rightAnchor, constant: 5),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -5),
            descriptionLabel.leftAnchor.constraint(equalTo: productImage.rightAnchor, constant: 5),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),

            callTagImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            callTagImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            callTagImageView.heightAnchor.constraint(equalToConstant: 20),
            callTagImageView.widthAnchor.constraint(equalToConstant: 20),

            cartTagImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cartTagImageView.leftAnchor.constraint(equalTo: callTagImageView.rightAnchor, constant: 5),
            cartTagImageView.heightAnchor.constraint(equalToConstant: 20),
            cartTagImageView.widthAnchor.constraint(equalToConstant: 20),
        ])
    }

    required init?(coder: NSCoder) { nil }

}
