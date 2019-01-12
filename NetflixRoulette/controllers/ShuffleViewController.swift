//
//  ShuffleViewController.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 22/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import UIKit

class ShuffleViewController: UIViewController {

    @IBOutlet weak var randomBox: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ShuffleViewController.tapDetected))
        randomBox.isUserInteractionEnabled = true
        randomBox.addGestureRecognizer(singleTap)
    }
    
    
    // Fonction à implémenter pour afficher une liste
    // aléatoire (entre 1 & 10 film(s)) à l'utilisateur
    @objc func tapDetected() {
        // TODO: call Web API with /random endpoint
        // fill list with response's movies 
        print("Imageview Clicked")
    }

}
