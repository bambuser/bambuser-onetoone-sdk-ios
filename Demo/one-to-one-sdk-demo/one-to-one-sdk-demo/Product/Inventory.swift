//
//  Inventory.swift
//  one-to-one-sdk-demo
//
//  Copyright © 2022 Bambuser. All rights reserved.
//

import Foundation
import BambuserLiveShoppingOnetoOne

public class Inventory {

    public private(set) var products: [Product]?

    public init() {
        self.createInventory()
    }

    private func createInventory() {
        products = [Product]()
        do {
            // Define some common color attributes
            let colorGrey = AttributeDefinitionOption(id: "oid_Grey", name: "Grey")
            let colorYellow = AttributeDefinitionOption(id: "oid_Yellow", name: "Yellow")
            let colorPink = AttributeDefinitionOption(id: "oid_Pink", name: "Pink")
            let colorBlack = AttributeDefinitionOption(id: "oid_Black", name: "Black")
            let colorWhite = AttributeDefinitionOption(id: "oid_White", name: "White")

            // Merino wool hat

            // Define color attribute
            let colorAttributeHat = try AttributeDefinition(id: "id_Color", name: "Color", options: [
                colorGrey,
                colorYellow,
                colorPink
            ])

            // use VariationFactory
            let variationFactory = VariationFactory()
            variationFactory.name = "Merino Wool Hat"
            variationFactory.price = Price(currency: "SEK", current: 200, original: 350)
            variationFactory.rating = Rating(rating: 5.00, maxValue: 5, numberOfRatings: 1)
            variationFactory.details = [.bullets(bullets: [
                "Soft stretch",
                "Pre-washed",
                "Very warm"
              ])]

            let productHat = try Product(
                attributes: [ colorAttributeHat ],
                brandName: "Bambuser",
                currency: "SEK",
                description: "Hat in a soft rib knit with a fold-up hem.",
                defaultVariationIndex: 0,
                locale: "en-US",
                name: "Merino Wool Hat",
                sku: "18",
                url: "https://demo.bambuser.shop/product/18/hat/",
                // create variations using the variation factory
                variations: [
                try variationFactory.createVariation(sku: "22", attributes: [
                    VariationAttribute(attribute: colorAttributeHat, option: colorYellow)], imageUrls: [
                        "https://demo.bambuser.shop/wp-content/uploads/2020/09/hat_yellow.png"
                      ]),
                try variationFactory.createVariation(sku: "23", attributes: [
                    VariationAttribute(attribute: colorAttributeHat, option: colorGrey)], imageUrls: [
                        "https://demo.bambuser.shop/wp-content/uploads/2020/09/hat_grey.png"
                      ]),
                try variationFactory.createVariation(sku: "24", attributes: [
                    VariationAttribute(attribute: colorAttributeHat, option: colorPink)], imageUrls: [
                        "https://demo.bambuser.shop/wp-content/uploads/2020/09/hat_pink.png"
                      ]),
                ])
            products?.append(productHat)

            // Luka tote bag

            // create the Product using only Product init
            let productBag = try Product(
                attributes: [
                    try AttributeDefinition(id: "id_Color", name: "Color", options: [
                        AttributeDefinitionOption(id: "oid_Black", name: "Black"),
                        AttributeDefinitionOption(id: "oid_Cognac", name: "Cognac")
                    ])
                ],
                brandName: "Bambuser",
                currency: "SEK",
                description: "This tote encapsulates Flattered’s timeless approach to design. The bag features a classic shape and will never go out of style thanks to its timeless black and cognac hue and gold-colored detailing. Designed in Stockholm and handcrafted in Montesilvano, Italy from fine Italian calf leather. A great bag for all occasions.",
                defaultVariationIndex: 1,
                locale: "en-US",
                name: "Luka Tote Bag",
                sku: "430",
                url: "https://demo.bambuser.shop/product/430/luka-tote-bag/",
                variations: [
                    Variation(
                        attributes: [
                            VariationAttribute(id: "id_Color", option: "oid_Black")
                        ],
                        comparableAttributes: [
                            ComparableVariationAttribute(id: "id_Material", name: "Material", option: "Leather"),
                            ComparableVariationAttribute(id: "id_Dimensions", name: "Dimension", option: "32x40x19cm")
                        ],
                        imageUrls: [
                            "https://demo.bambuser.shop/wp-content/uploads/2021/03/Luka_black.png"
                        ],
                        inStock: true,
                        name: "Luka Tote Bag",
                        price: Price(currency: "SEK", current: 2500),
                        rating: Rating(rating: 4.00, maxValue: 5, numberOfRatings: 1),
                        sku: "431",
                        url: "https://demo.bambuser.shop/product/431/luka-tote-bag/"),
                    Variation(
                        attributes: [
                            VariationAttribute(id: "id_Color", option: "oid_Cognac")
                        ],
                        comparableAttributes: [
                            ComparableVariationAttribute(id: "id_Material", name: "Material", option: "Leather"),
                            ComparableVariationAttribute(id: "id_Dimensions", name: "Dimension", option: "32x40x19cm")
                        ],
                        imageUrls: [
                            "https://demo.bambuser.shop/wp-content/uploads/2021/03/Luka_cognac.png"
                        ],
                        inStock: true,
                        name: "Luka Tote Bag",
                        price: Price(currency: "SEK", current: 200, original: 350),
                        rating: Rating(rating: 5.00, maxValue: 5, numberOfRatings: 1),
                        sku: "432",
                        url: "https://demo.bambuser.shop/product/432/luka-tote-bag/"),
                ])
            products?.append(productBag)

            // Hoodie

            // Define color attributes
            let colorAttributeHoodie = try AttributeDefinition(id: "id_Color", name: "Color", options: [
                colorBlack,
                colorWhite
            ])

            // Define size attributes
            let sizeSmall = AttributeDefinitionOption(id: "oid_Small", name: "Small")
            let sizeMedium = AttributeDefinitionOption(id: "oid_Medium", name: "Medium")
            let sizeLarge = AttributeDefinitionOption(id: "oid_Large", name: "Large")
            let sizeXLarge = AttributeDefinitionOption(id: "oid_X-Large", name: "X-Large")
            let sizeAttributeHoodie = try AttributeDefinition(id: "id_Size", name: "Size", options: [
                sizeSmall,
                sizeMedium,
                sizeLarge,
                sizeXLarge
            ])

            var productHoodie = try Product(attributes: [ colorAttributeHoodie, sizeAttributeHoodie ], brandName: "Bambuser", currency: "SEK", description: "Jacket in sweatshirt fabric with a jersey-lined drawstring hood, zip down the front, side pockets and ribbing at the cuffs and hem. Soft brushed inside. Regular Fit.", defaultVariationIndex: 0, locale: "en-US", name: "Bambuser hoodie", sku: "14", url: "https://demo.bambuser.shop/product/14/bambuser-hoodie/")

            // Use VariationFactory
            let variationFactoryHoodie = VariationFactory()
            variationFactoryHoodie.name = "Bambuser hoodie"
            variationFactoryHoodie.comparableAttributes = [
                ComparableVariationAttribute(id: "id_Year of manufacturing",
                                             name: "Year of manufacturing",
                                             option: "2020"),
            ]
            variationFactoryHoodie.details = [.bullets(bullets: [
                "Awesome hoodie",
                "Set approves",
              ])]
            variationFactoryHoodie.rating = Rating(rating: 4.00, maxValue: 5, numberOfRatings: 1)
            variationFactoryHoodie.price = Price(currency: "SEK", current: 450, original: 799)

            // use setVariations
            try productHoodie.setVariations(variations: [
                try variationFactoryHoodie.createVariation(
                    sku: "513",
                    attributes: [
                        VariationAttribute(attribute: colorAttributeHoodie, option: colorBlack),
                        VariationAttribute(attribute: sizeAttributeHoodie, option: sizeSmall)],
                    imageUrls: [
                        "https://demo.bambuser.shop/wp-content/uploads/2021/07/black-hoodie-front.png"
                      ],
                    url: "https://demo.bambuser.shop/product/513/bambuser-hoodie/"),
                try variationFactoryHoodie.createVariation(
                    sku: "514",
                    attributes: [
                        VariationAttribute(attribute: colorAttributeHoodie, option: colorWhite),
                        VariationAttribute(attribute: sizeAttributeHoodie, option: sizeSmall)],
                    imageUrls: [
                        "https://demo.bambuser.shop/wp-content/uploads/2021/07/white-hoodie-front.png"
                      ],
                    url: "https://demo.bambuser.shop/product/514/bambuser-hoodie/"),
                try variationFactoryHoodie.createVariation(
                    sku: "515",
                    attributes: [
                        VariationAttribute(attribute: colorAttributeHoodie, option: colorBlack),
                        VariationAttribute(attribute: sizeAttributeHoodie, option: sizeMedium)],
                    imageUrls: [
                        "https://demo.bambuser.shop/wp-content/uploads/2021/07/black-hoodie-front.png"
                      ],
                    url: "https://demo.bambuser.shop/product/515/bambuser-hoodie/"),
                try variationFactoryHoodie.createVariation(
                    sku: "516",
                    attributes: [
                        VariationAttribute(attribute: colorAttributeHoodie, option: colorWhite),
                        VariationAttribute(attribute: sizeAttributeHoodie, option: sizeMedium)],
                    imageUrls: [
                        "https://demo.bambuser.shop/wp-content/uploads/2021/07/white-hoodie-front.png"
                      ],
                    url: "https://demo.bambuser.shop/product/516/bambuser-hoodie/"),
                try variationFactoryHoodie.createVariation(
                    sku: "517",
                    attributes: [
                        VariationAttribute(attribute: colorAttributeHoodie, option: colorBlack),
                        VariationAttribute(attribute: sizeAttributeHoodie, option: sizeLarge)],
                    imageUrls: [
                        "https://demo.bambuser.shop/wp-content/uploads/2021/07/black-hoodie-front.png"
                      ],
                    url: "https://demo.bambuser.shop/product/517/bambuser-hoodie/"),
                try variationFactoryHoodie.createVariation(
                    sku: "518",
                    attributes: [
                        VariationAttribute(attribute: colorAttributeHoodie, option: colorWhite),
                        VariationAttribute(attribute: sizeAttributeHoodie, option: sizeLarge)],
                    imageUrls: [
                        "https://demo.bambuser.shop/wp-content/uploads/2021/07/white-hoodie-front.png"
                      ],
                    url: "https://demo.bambuser.shop/product/518/bambuser-hoodie/"),
                try variationFactoryHoodie.createVariation(
                    sku: "519",
                    attributes: [
                        VariationAttribute(attribute: colorAttributeHoodie, option: colorBlack),
                        VariationAttribute(attribute: sizeAttributeHoodie, option: sizeXLarge)],
                    imageUrls: [
                        "https://demo.bambuser.shop/wp-content/uploads/2021/07/black-hoodie-front.png"
                      ],
                    url: "https://demo.bambuser.shop/product/519/bambuser-hoodie/"),
                try variationFactoryHoodie.createVariation(
                    sku: "520",
                    attributes: [
                        VariationAttribute(attribute: colorAttributeHoodie, option: colorWhite),
                        VariationAttribute(attribute: sizeAttributeHoodie, option: sizeLarge)],
                    imageUrls: [
                        "https://demo.bambuser.shop/wp-content/uploads/2021/07/white-hoodie-front.png"
                      ],
                    url: "https://demo.bambuser.shop/product/520/bambuser-hoodie/"),
            ])
            products?.append(productHoodie)

            // Bambuser cap. A product with just one variation
            let productCap = try Product(
                brandName: "Bambuser",
                currency: "SEK",
                description: "A fantastic cap to wear.",
                locale: "en-US", name: "Bambuser cap",
                sku: "551", url: "https://demo.bambuser.shop/product/551/bambuser-cap/",
                variations: [
                    Variation(imageUrls: [ "https://demo.bambuser.shop/wp-content/uploads/2021/11/bambuser_cap.png" ], name: "Bambuser Cap", price: Price(currency: "SEK", current: 300), rating: Rating(rating: 0, maxValue: 5, numberOfRatings: 0), sku: "551", url:  "https://demo.bambuser.shop/product/551/bambuser-cap/")
                ])
            products?.append(productCap)

            // Cream. A product with just one variation
            let productCream = try Product(
                brandName: "Bambuser",
                currency: "SEK",
                description: "This Ceramide Cream's rich texture imitates the lamellar structure of the hydrolipid barrier and supports the skin's own natural protective function. Combining lipids and ceramides similar to those naturally found in the skin, this cream helps to equalize disturbances in the skin's barrier function and helps to protect against moisture loss. Use in the morning and/or evening, after cleansing, and after the active concentrate. Free from fragrance and artificial colorants.",
                locale: "en-US",
                name: "Ceramide Cream",
                sku: "396",
                url: "https://demo.bambuser.shop/product/396/ceramide-cream/",
                variations: [
                    Variation(
                              comparableAttributes: [
                              ComparableVariationAttribute(id: "id_Volume", name: "Volume", option: "50ml"),
                              ComparableVariationAttribute(id: "id_Consistency", name: "Consistency", option: "Cream")],
                              imageUrls: [
                                "https://demo.bambuser.shop/wp-content/uploads/2021/03/CeramideCream.png"],
                              name: "Ceramide Cream",
                              price: Price(currency: "SEK", current: 650),
                              rating: Rating(rating: 0.0, maxValue: 5, numberOfRatings: 0),
                              sku: "396",
                              url: "https://demo.bambuser.shop/product/396/ceramide-cream/")
                ])
            products?.append(productCream)
        } catch ProductSpecError.undefinedAttributeDefinition(let description) {
            print("exception thrown: \(description)")
        } catch ProductSpecError.multipleDefinedAttributeDefinition(let description) {
            print("exception thrown: \(description)")
        } catch ProductSpecError.undefinedOption(let description) {
            print("exception thrown: \(description)")
        } catch ProductSpecError.typeError(let description) {
            print("exception thrown: \(description)")
        } catch {
            print("Unexpected error")
        }
    }
}
