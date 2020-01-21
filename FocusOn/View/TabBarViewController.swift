//
//  TabBarViewController.swift
//  FocusOn
//
//  Created by Am GHAZNAVI on 10/11/2019.
//  Copyright © 2019 Am GHAZNAVI. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // To customise tab bar
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = .red

        // To select TodayViewController
        self.selectedIndex = 1
    }
    
}
