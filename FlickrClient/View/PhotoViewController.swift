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
    @IBOutlet weak var nav: UINavigationItem!
    
    public var photo: Photo? = nil
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
