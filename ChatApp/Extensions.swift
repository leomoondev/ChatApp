//
//  Extensions.swift
//  ChatApp
//
//  Created by Hyung Jip Moon on 2017-04-27.
//  Copyright © 2017 leomoon. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        // Check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // Otherwise fire off a new download
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: {(data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage

                }
                // do something
                // cell.imageView?.image = UIImage(data: data!)
            }
        }).resume()
    }
}
