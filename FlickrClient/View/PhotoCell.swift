//
//  PhotoCell.swift
//  FlickrClient
//
//  Created by Tyts on 16.12.2019.
//  Copyright © 2019 Tyts&Co. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    func configure(photo: Photo) {

        if let image = photo.image {
            photoImageView.image = image
        } else {
            photo.size = .small_320x
            print(photo.url)
            photoImageView.load(photo: photo)
        }
        
    }
    
    override func prepareForReuse() {
        photoImageView.image = nil
    }
}

extension UIImageView {
    func load(photo: Photo) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: photo.url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        photo.image = image
                    }
                }
            }
        }
    }
}

