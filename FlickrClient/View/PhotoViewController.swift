//
//  PhotoViewController.swift
//  FlickrClient
//
//  Created by Tyts on 22.12.2019.
//  Copyright © 2019 Tyts&Co. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak private var imageView: UIImageView!
    public var photo: Photo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }
    
     private func loadImage() -> Void {
        if let photo = self.photo {
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.center = self.view.center
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
            
            let url = photo.url(size: Photo.largeImageSize)
            if let image = photo.loadImage(by: url) {
                photo.largeImage = image
                imageView.image = photo.largeImage
                self.title = photo.title
            }
            activityIndicator.removeFromSuperview()
        }
        
     }
}
