//
//  ImageManager.swift
//  one-to-one-sdk-demo
//
//  Copyright © 2022 Bambuser. All rights reserved.
//

import UIKit

class ImageManager: NSObject {

	private let imageCache: NSCache = NSCache<NSString, UIImage>()

	static let shared: ImageManager = ImageManager()
	private override init() {}

	func downloadImage(url: String, completion: @escaping ((_ image: UIImage?) -> Void)) {
		if let image: UIImage = imageCache.object(forKey: url as NSString) {
			completion(image)
		} else {
			getData(fromUrl: url) { data in
				guard let imageData: Data = data else { return completion(nil) }

				if let image: UIImage = UIImage(data: imageData) {
					self.imageCache.setObject(image, forKey: url as NSString)
					completion(image)
				} else {
					completion(nil)
				}
			}
		}
	}

	private func getData(fromUrl: String, completion: @escaping ((_ data: Data?) -> Void)) {
		URLSession.shared.dataTask(with: NSURL(string: fromUrl)! as URL) { (data, _, _) in
			completion(data)
		}.resume()
	}

}
