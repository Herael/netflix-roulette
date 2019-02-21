//
//  HomeViewController.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 19/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {
    
    var userLogin: String = "$"
    var userId: Int = 0
    var userAuthToken: String = "$"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Netflix Roulette"
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: UIImage(named: "leave"), style: .done, target: self, action: #selector(disconnect))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
        self.navigationItem.setHidesBackButton(true, animated: true)
        tabBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue:  0/255, alpha: 1)
        self.tabBar.tintColor = UIColor.red
        setTabBar()
    }

    @objc func disconnect(){
        let main_vc = MainViewController()
        self.navigationController?.pushViewController(main_vc, animated: true)
    }
    

    
    func setTabBar(){
        
        let homeVc = UINavigationController(rootViewController: AcceuilViewController())
        homeVc.tabBarItem.image = UIImage(named: "home-white")
        homeVc.tabBarItem.title = "Home"
        
        
        let searchVc = UINavigationController(rootViewController: SearchViewController())
        searchVc.tabBarItem.image = UIImage(named: "search")
        searchVc.tabBarItem.title = "Search"
        
        let shuffleVc = UINavigationController(rootViewController: ShuffleViewController())
        shuffleVc.tabBarItem.image = UIImage(named: "shuffle-white")
        shuffleVc.tabBarItem.title = "Shuffle mode"
        
        let favoriteVc = UINavigationController(rootViewController: FavoriteViewController())
        favoriteVc.tabBarItem.image = UIImage(named: "fav_white_full")
        favoriteVc.tabBarItem.title = "Favorites"
        
        viewControllers = [homeVc, searchVc, shuffleVc, favoriteVc]
    }
  
}
