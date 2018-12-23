//
//  MainViewController.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 19/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign in"
        // Do any additional setup after loading the view.
    }

    @IBAction func sign(_ sender: Any) {
       print("test")
       let home = HomeViewController()
       self.navigationController?.pushViewController(home, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
