//
//  UIImageView+Extensions.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/27.
//

import UIKit

extension UIImageView {
    static let imageCache = NSCache<AnyObject, AnyObject>()
    func cacheImage(imageUrlString: String) {
        let url = URL(string: imageUrlString)
        if let imageFromCache = UIImageView.imageCache.object(forKey: imageUrlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        self.image = UIImage(named: "placeholder")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data:data!)
                self.image = imageToCache
                UIImageView.imageCache.setObject(imageToCache!, forKey: imageUrlString as AnyObject)
            }
        }.resume()
    }
}
