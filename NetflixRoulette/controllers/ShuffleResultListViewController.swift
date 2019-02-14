//
//  ShuffleResultListViewController.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 02/02/2019.
//  Copyright © 2019 Ramzy Kermad. All rights reserved.
//

import UIKit

class ShuffleResultListViewController: UIViewController {

    @IBOutlet var mediaResultList: UITableView!
    var movies : [Movie] = []
    var shows : [Show] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mediaResultList.delegate = self
        self.mediaResultList.dataSource = self
        self.mediaResultList.register(UINib(nibName: "MovieSearchTableViewCell", bundle: nil), forCellReuseIdentifier: ShuffleResultListViewController.movieCellId)
    }



}

extension ShuffleResultListViewController: UITableViewDelegate {
    
    
}

extension ShuffleResultListViewController: UITableViewDataSource {
    
    public static let movieCellId = "MOVIE_SEARCH_CELL_IDENTIFIER"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return movies.count + shows.count
        return movies.count
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
