//
//  PhotoCell.swift
//  FlickrClient
//
//  Created by Tyts on 16.12.2019.
//  Copyright © 2019 Tyts&Co. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var index = 0
  
    override func prepareForReuse() {
        self.imageView.image = nil
    }
}
