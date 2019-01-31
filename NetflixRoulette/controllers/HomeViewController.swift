//
//  HomeViewController.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 19/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {
    
    var user_params: User!
    var main_user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Netflix Roulette"
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: UIImage(named: "disconnect"), style: .done, target: self, action: #selector(disconnect))
        self.navigationItem.setHidesBackButton(true, animated: true)
        tabBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue:  0/255, alpha: 1)
        setTabBar()
        
        //main_user = User(id: userId, login: userLogin, token: userToken)
        
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
        
        viewControllers = [homeVc, searchVc, shuffleVc]
    }
  
}
