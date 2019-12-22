//
//  FlickrPhoto.swift
//  FlickrClient
//
//  Created by Tyts on 16.12.2019.
//  Copyright © 2019 Tyts&Co. All rights reserved.
//

import Foundation
import UIKit

class Photo {
 
    private let flickrPhoto: FlickrPhoto
    static let largeImageSize: flickrPhotoSize = .large_1024x
    static let thumbnailSize: flickrPhotoSize = .small_320x
    var largeImage: UIImage?
    var thumbnail: UIImage?
    var title: String {
        return flickrPhoto.title
    }

    init(flickrPhoto: FlickrPhoto) {
        self.flickrPhoto = flickrPhoto
    }
    
    func url(size: flickrPhotoSize) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "farm\(self.flickrPhoto.farm).staticflickr.com"
        components.path = "/\(self.flickrPhoto.server)/\(self.flickrPhoto.id)_\(self.flickrPhoto.secret)_\(size.rawValue).jpg"
        return components.url!
    }
    
    func loadImage(by url: URL) -> UIImage? {
        if let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            return image
        } else {
            return nil
        }
    }
}

enum flickrPhotoSize: String {

    case small_75x75    = "s"    //small square 75x75
    case large_150x150  = "q"    //large square 150x150
    case thumbnail_100x = "t"    //thumbnail, 100 on longest side
    case small_240x     = "m"    //small, 240 on longest side
    case small_320x     = "n"    //small, 320 on longest side
    case medium_500x    = "-"    //medium, 500 on longest side
    case medium_640x    = "z"    //medium 640, 640 on longest side
    case medium_800x    = "c"    //medium 800, 800 on longest side†
    case large_1024x    = "b"    //large, 1024 on longest side*
    case large_1600x    = "h"    //large 1600, 1600 on longest side†
    case large_2048x    = "k"    //large 2048, 2048 on longest side†
    case original       = "o"    //original image, either a jpg, gif or png, depending on source format

}
