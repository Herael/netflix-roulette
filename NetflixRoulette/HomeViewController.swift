//
//  HomeViewController.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 19/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Netflix Roulette"
        self.navigationItem.setHidesBackButton(true, animated: true)

        tabBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue:  0/255, alpha: 1)        
        setTabBar()
    }

    func setTabBar(){
        
        let homeVc = UINavigationController(rootViewController: AcceuilViewController())
        homeVc.tabBarItem.image = UIImage(named: "home")
        homeVc.tabBarItem.title = "Home"
        
        let searchVc = UINavigationController(rootViewController: SearchViewController())
        searchVc.tabBarItem.image = UIImage(named: "search")
        searchVc.tabBarItem.title = "Search"
        
        let shuffleVc = UINavigationController(rootViewController: ShuffleViewController())
        shuffleVc.tabBarItem.image = UIImage(named: "shuffle")
        shuffleVc.tabBarItem.title = "Shuffle mode"
        
        viewControllers = [homeVc, searchVc, shuffleVc]
    }
  
}
