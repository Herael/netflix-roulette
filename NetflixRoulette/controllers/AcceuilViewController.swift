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
    @IBOutlet weak var randomMovieOfTheDay: UIImageView!
    var random_movie_details: Movie!    // Load here the response of the API call
    
    
    @IBOutlet weak var home_page_title: UILabel!
    
    
    @IBOutlet var popularCollection: UICollectionView!
    @IBOutlet var ratedMovie: UICollectionView!
    
    
    var movieTitle: String = ""
    var movieId: Int = 0
    var moviePoster: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadMoviePicture()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ShuffleViewController.tapDetected))
        randomMovieOfTheDay.isUserInteractionEnabled = true
        randomMovieOfTheDay.addGestureRecognizer(singleTap)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tabBarCtrl = self.tabBarController as! HomeViewController
        let login = tabBarCtrl.userLogin
        home_page_title.text = "Hi \(login)! There is a daily movie just for you! 😉"
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: nil)
    }
    
    @objc func tapDetected() {
        print("Show description")
        getRandomMovie()
    }
    
    func uploadMoviePicture(){
        MovieService.default.getHomeRandomMovie(completion: {(movie_title, movie_poster, movie_id) in
            self.movieId = movie_id
            self.movieTitle = movie_title
            self.moviePoster = movie_poster
            if movie_poster != ""{
                self.randomMovieOfTheDay.af_setImage(withURL: URL(string: movie_poster)!)
            }else{
                self.uploadMoviePicture()
                //self.randomMovieOfTheDay.image = UIImage(named: "noPicture")
            }
        })
    }
    
    func getRandomMovie(){
        self.getRandomMovieDetails(movie_title: self.movieTitle,
                                   movie_id: self.movieId,
                                   movie_poster: self.moviePoster)
    }
    
    func getRandomMovieDetails(movie_title: String, movie_id: Int, movie_poster: String){
        let item_description = ItemDescriptionViewController()
        item_description.movie_title = movie_title
        item_description.movie_id = movie_id
        item_description.movie_image_url = movie_poster
        self.navigationController?.pushViewController(item_description, animated: true)
    }
}
