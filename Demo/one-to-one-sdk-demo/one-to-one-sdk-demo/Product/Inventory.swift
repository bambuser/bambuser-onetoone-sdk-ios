//
//  Inventory.swift
//  one-to-one-sdk-demo
//
//  Copyright © 2022 Bambuser. All rights reserved.
//

import Foundation

/**
 Note! This shall not be seen as an example on how to set up a Product structure. This is just for demo purposes.
 */
public struct Inventory: Codable, Equatable {

    public private(set) var products: [Product]

    public init() {
        self.products = [Product]()
        products.append(Product(sku: "14", id: "tpl:c683b4e2c1a1213e11dfd6e883550fa485df1f3f", title: "Bambuser hoodie", description: "Jacket in sweatshirt fabric with a jersey-lined drawstring hood, zip down the front, side pockets and ribbing at the cuffs and hem. Soft brushed inside. Regular Fit.", imageUrl: "https://demo.bambuser.shop/wp-content/uploads/2021/11/Hoodie_bambuser-merchlogo-removed.png"))

        products.append(Product(sku: "15", id: "tpl:a7fcfe998b7189770bf7f3841e8a37b1798a347f", title: "Bambuser tote bag", description: "Tote bag in durable canvas. Easy to pack for travelling, it offers extra luggage space and works well for shopping, beach days and picnic. Robust handles allow for carrying heavier items. Print with Bambuser logo.", imageUrl: "https://demo.bambuser.shop/wp-content/uploads/2021/11/bb-tote.png"))

        products.append(Product(sku: "84", id: "tpl:eea7658e489ae360336331e7fcfb74b6bc21530b", title: "Bambuser cup", description: "Enamel mug with printed Bambuser logo.", imageUrl: "https://demo.bambuser.shop/wp-content/uploads/2021/11/Cup_bambuser-merch.png"))

        products.append(Product(sku: "92", id: "tpl:f429dba8cc5f1f18c931e5be003c853297dde579", title: "Smartphone case", description: "Soft silicone shell that protects your smartphone from scratches and turns your smartphone into a fashion accessory.", imageUrl: "https://demo.bambuser.shop/wp-content/uploads/2021/11/mobile-shell_green.png"))
    }
}
