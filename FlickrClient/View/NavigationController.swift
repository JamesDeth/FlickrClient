//
//  NavigationController.swift
//  FlickrClient
//
//  Created by Tyts on 22.12.2019.
//  Copyright © 2019 Tyts&Co. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    @IBOutlet weak var tabBar: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationVC = segue.destination as! PhotoCollectionViewContorller
        destinationVC.fetcherPage = self.tabBar.title!
        
    }
    

}
