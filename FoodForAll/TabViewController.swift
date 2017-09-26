//
//  TabViewController.swift
//  FoodForAll
//
//  Created by amit on 4/25/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    // self.tabBar.isTranslucent = false
       
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
