//
//  Product.swift
//  one-to-one-sdk-demo
//
//  Copyright © 2022 Bambuser. All rights reserved.
//

import Foundation

/**
 Note! This shall not be seen as an example on how to set up a Product structure. This is just for demo purposes.
 */
public struct Product: Codable, Equatable {

    public let sku: String
    public let id: String
    public let title: String
    public let description: String
    public let imageUrl: String
}
