//
//  AcceuilViewController.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 22/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

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
        randomMovieOfTheDay.image = UIImage(named: "home-white")
    }
    
    func getRandomMovieTitle(){
        var random_movie_title: String = ""
        var random_movie_id: Int = 0
        
        // Make a call to endpoint (A)
        let params: [String : Any] = [
            "nb": 1
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-BetaSeries-Key": "ef873e84f313",
            "X-BetaSeries-Version": "3.0"
        ]
        _ = Alamofire.request("https://api.betaseries.com/movies/random", method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response: DataResponse<Any>) in
            print(response)
            
            guard let json_response = response.result.value as? [String: Any],
                    let movie_description = json_response["movies"] as? [Any],
                        let random_movie = movie_description[0] as? [String: Any],
                            let random_title = random_movie["title"] as? String,
                            let random_id = random_movie["id"] as? Int else{
                    return
            }
        
            random_movie_title = random_title
            random_movie_id = random_id
            
            print("title of the random movie: \(random_movie_title)")
            self.getRandomMovieDetails(movie_title: random_movie_title, movie_id: random_movie_id)
        }
        
    }
    
    func getRandomMovieDetails(movie_title: String, movie_id: Int){
        //Make call to endpoint (B)
        // Send useful information to ItemDescriptionViewController
        
        let item_description = ItemDescriptionViewController()
        item_description.movie_title = movie_title
        item_description.movie_id = movie_id
        self.navigationController?.pushViewController(item_description, animated: true)
    }
}