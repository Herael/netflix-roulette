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
    
    var upcomingMovies : [[String]] = []
    var popularMovies : [[String]] = []
    
    @IBOutlet weak var home_page_title: UILabel!
    
    
    @IBOutlet var popularCollection: UICollectionView!
    @IBOutlet var ratedCollection: UICollectionView!
    
    var movieTitle: String = ""
    var movieId: Int = 0
    var moviePoster: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadMoviePicture()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ShuffleViewController.tapDetected))
        randomMovieOfTheDay.isUserInteractionEnabled = true
        randomMovieOfTheDay.addGestureRecognizer(singleTap)
        self.popularCollection.delegate = self
        self.popularCollection.dataSource = self
        self.ratedCollection.delegate = self
        self.ratedCollection.dataSource = self
        self.popularCollection.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: AcceuilViewController.movieCellId)
        self.ratedCollection.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: AcceuilViewController.movieCellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tabBarCtrl = self.tabBarController as! HomeViewController
        let login = tabBarCtrl.userLogin
        home_page_title.text = "Hi \(login)! There is a daily movie just for you! 😉"
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: nil)
    }
    
    @objc func tapDetected() {
        getRandomMovie()
    }
    
    func uploadMoviePicture(){
        MovieService.default.getHomeRandomMovie(completion: {(movie_title, movie_poster, movie_id) in
            self.movieId = movie_id
            self.movieTitle = movie_title
            self.moviePoster = movie_poster
            if movie_poster != ""{
                self.randomMovieOfTheDay.af_setImage(withURL: URL(string: movie_poster)!)
                self.getTop4PopularUpcomingMovies()
            }else{
                self.uploadMoviePicture()
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

    func getTop4PopularUpcomingMovies(){
        MovieService.default.getPopularUpcomingMovies { (popular_upcoming_movies) in
            self.upcomingMovies = popular_upcoming_movies
            if(self.upcomingMovies.count == 4){
                self.popularCollection.reloadData()
                self.getTop4BestPopularMovies()
            }
        }
    }
    
    func getTop4BestPopularMovies(){
        MovieService.default.getBestPopularMovies { (popular_movies) in
            self.popularMovies = popular_movies
            if(self.popularMovies.count == 4){
                self.ratedCollection.reloadData()
            }
        }
    }
}

extension AcceuilViewController: UICollectionViewDelegate {
    
}

extension AcceuilViewController: UICollectionViewDataSource {
    
    public static let movieCellId = "MOVIE_HOME_CELL"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upcomingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: AcceuilViewController.movieCellId, for: indexPath) as! MovieCollectionViewCell
        if self.upcomingMovies.count != 0 {
            
            if self.upcomingMovies[indexPath.item][2] != "" {
                let imageURL = URL(string: self.upcomingMovies[indexPath.item][2])
                let imageData = try! Data(contentsOf: imageURL!)
                movieCell.moviePicture.image = UIImage(data: imageData)
                movieCell.id = self.upcomingMovies[indexPath.item][0]
            }else{
                movieCell.moviePicture.image = UIImage(named: "noPicture")
            }
        }
        
        if self.popularMovies.count != 0 {
            
            if self.popularMovies[indexPath.item][2] != "" {
                let imageURL = URL(string: self.popularMovies[indexPath.item][2])
                let imageData = try! Data(contentsOf: imageURL!)
                movieCell.moviePicture.image = UIImage(data: imageData)
                movieCell.id = self.popularMovies[indexPath.item][0]
            }else{
                movieCell.moviePicture.image = UIImage(named: "noPicture")
            }
        }
        
        return movieCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! MovieCollectionViewCell
        let id = cell.id
        for i in 0..<upcomingMovies.count{
            if Int(upcomingMovies[i][0]) == Int(id){
                let item_description = ItemDescriptionViewController()
                item_description.movie_title = upcomingMovies[i][1]
                item_description.movie_id = Int(upcomingMovies[i][0])
                item_description.movie_image_url = upcomingMovies[i][2]
                self.navigationController?.pushViewController(item_description, animated: true)
            }
        }
        for i in 0..<popularMovies.count{
            if Int(popularMovies[i][0]) == Int(id){
                let item_description = ItemDescriptionViewController()
                item_description.movie_title = popularMovies[i][1]
                item_description.movie_id = Int(popularMovies[i][0])
                item_description.movie_image_url = popularMovies[i][2]
                self.navigationController?.pushViewController(item_description, animated: true)
            }
        }
    }
}
