//
//  ImageCache.swift
//  rawgGamesSearch
//
//  Created by Artem Kvashnin on 17.08.2022.
//

import Foundation
import UIKit

public class ImageCache {
    static let publicImageCache = ImageCache()
    private let cachedImages = NSCache<NSURL, UIImage>()
    
    func cachedImage(for url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    func load(for url: NSURL, game: Game, completion: @escaping (Game, UIImage) -> Void) {
        
        //Check for cached image and call completion if image exists
        if let cachedImage = cachedImage(for: url) {
            DispatchQueue.main.async {
                completion(game, cachedImage)
            }
            return
        }
        
        //If there is no chaced image, fetch it and cache
        
        
    }
}
