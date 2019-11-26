//
//  Validator+TN.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import UIKit

extension UIImageView {
    
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    public func setImageFromURL(withUrlString urlString:String?, placeHolderImage image:UIImage?) {
        
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
                self.image = image
                return
        }
        
        if let cachedImage = UIImageView.imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    self.image = image
                    return
                }
                if let image = UIImage(data: data) {
                    self.image = image
                    UIImageView.imageCache.setObject(image, forKey: urlString as AnyObject)
                }
                else {
                    self.image = image
                }
            }
        }).resume()
    }
}
