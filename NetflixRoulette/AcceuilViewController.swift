//
//  AcceuilViewController.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 22/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import UIKit

class AcceuilViewController: UIViewController {
    
    @IBOutlet weak var randomMovieOfTheDay: UIImageView!
    @IBOutlet weak var page_title: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadMoviePicture()
        
    }
    
    // Function à implémenter au moment de l'appel à l'API
    // pour afficher l'affiche du film du jour
    func uploadMoviePicture(){
        randomMovieOfTheDay.image = UIImage(named: "home")
    }
    
    
    

}
