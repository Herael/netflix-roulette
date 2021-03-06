//
//  FavoriteViewController.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 07/02/2019.
//  Copyright © 2019 Ramzy Kermad. All rights reserved.
//

import UIKit
import Alamofire

class FavoriteViewController: UIViewController {

    @IBOutlet weak var mediaResultList: UITableView!
    var movies : [Movie] = []
    var shows : [Show] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mediaResultList.delegate = self
        self.mediaResultList.dataSource = self
        self.mediaResultList.register(UINib(nibName: "MovieSearchTableViewCell", bundle: nil), forCellReuseIdentifier: ShuffleResultListViewController.movieCellId)
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.leftBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(touchEditTableView)),
        ]
        self.tabBarController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.red
        getFavoriteMovies(completion: { movies in
            self.movies = movies
            self.mediaResultList.reloadData()
        })
    }
    
    
    @objc func touchEditTableView() {
        UIView.animate(withDuration: 0.33) {
            self.mediaResultList.isEditing = !self.mediaResultList.isEditing
        }
    }
    
    @objc func disconnect(){
        let main_vc = MainViewController()
        self.navigationController?.pushViewController(main_vc, animated: true)
    }

    func getFavoriteMovies(completion: @escaping ([Movie]) -> Void){
        let tabBarConcroller = self.tabBarController as! HomeViewController
        let userId = tabBarConcroller.userId
        FavMovieServices.default.getFavsMovies(userId: userId, completion: { movies in
            completion(movies as! [Movie])
        })
    }

}


extension FavoriteViewController: UITableViewDelegate {

    
    // Catch du swipe de droite vers la gauche pour la suppression
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Faire la suppression du film sur l'API ici
            let tabBarCtrl = self.tabBarController as! HomeViewController
            let authToken = tabBarCtrl.userAuthToken
            
            FavMovieServices.default.deleteMovieFromFavorite(movieID: self.movies[indexPath.row].id,
                                                             userAuthToken: authToken)
            movies.remove(at: indexPath.row)
            self.mediaResultList.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

extension FavoriteViewController: UITableViewDataSource {
    
    public static let movieCellId = "MOVIE_SEARCH_CELL_IDENTIFIER"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return movies.count + shows.count
        return movies.count
    }
    
    // Fonction qui permet d'afficher les 3 barres sur chaque cellule pour change de place
    // à un film
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let removed = self.movies.remove(at: sourceIndexPath.row)
        self.movies.insert(removed, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movieCell = tableView.dequeueReusableCell(withIdentifier: SearchViewController.mediaCellId, for: indexPath) as! MovieSearchTableViewCell
        let movie = self.movies[indexPath.row]
        movieCell.titleLabel.text = movie.title
        
        if movie.picture != ""{
            let imageURL = URL(string: movie.picture)
            movieCell.typeImageView.af_setImage(withURL: imageURL!)
            //.image = UIImage(data: imageURL?)
        }
        
        movieCell.releaseDateLabel.text = "Sortie : " + String(movie.production_year)
        movieCell.lengthLabel.text = "Durée : " + String(movie.length/60) + " min"
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.red
        movieCell.selectedBackgroundView = backgroundView
        
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let item_description = ItemDescriptionViewController()
        item_description.movie_title = self.movies[indexPath.row].title
        item_description.movie_id = self.movies[indexPath.row].id
        item_description.movie_image_url = self.movies[indexPath.row].picture
        self.navigationController?.pushViewController(item_description, animated: true)
    }
    
    
}

