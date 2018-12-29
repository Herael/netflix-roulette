//
//  AcceuilViewController.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 22/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import UIKit

class AcceuilViewController: UIViewController {
    
    /** (A°
     ** Endpoint to reach to get the title of a random movie,
     ** then put in in a json and reach the endpoint bellow
     **                                                 |
     https://api.betaseries.com/movies/random           |
     **                                                 |
                                                        |
                                                        |
     ** (B)                                             V
     ** Endpoint to reach to get all info about a movie from his
     **
    https://api.betaseries.com/movies/search
    **
    **/
    
    
    
    @IBOutlet weak var randomMovieOfTheDay: UIImageView!
    var random_movie_details: Movie!    // Load here the response of the API call
    
    @IBOutlet weak var page_title: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadMoviePicture()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ShuffleViewController.tapDetected))
        randomMovieOfTheDay.isUserInteractionEnabled = true
        randomMovieOfTheDay.addGestureRecognizer(singleTap)
        
    }
    
    @objc func tapDetected() {
        print("Show description")
        getRandomMovieTitle()
    }
    
    // Function à implémenter au moment de l'appel à l'API
    // pour afficher l'affiche du film du jour
    func uploadMoviePicture(){
        randomMovieOfTheDay.image = UIImage(named: "home")
    }
    
    func getRandomMovieTitle(){
        // Make a call to endpoint (A)
        
        // When done
        getRandomMovieDetails()
    }
    
    func getRandomMovieDetails(){
        //Make call to endpoint (B)
        // Send useful information to ItemDescriptionViewController
        let item_description = ItemDescriptionViewController()
        self.navigationController?.pushViewController(item_description, animated: true)
    }
}
