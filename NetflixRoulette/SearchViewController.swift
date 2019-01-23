//
//  SearchViewController.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 22/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController , UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var movies : [Movie] = []
    var shows : [Show] = []
    
    
    class func newInstance(movies: [Movie], shows: [Show]) -> SearchViewController {
        
        let svc = SearchViewController()
        svc.movies = movies
        svc.shows = shows
        return svc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.becomeFirstResponder()
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).keyboardAppearance = .dark
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MovieSearchTableViewCell", bundle: nil), forCellReuseIdentifier: SearchViewController.movieCellId)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        guard (searchBar.text) != nil else{
            return
        }
        self.searchAPI(title: searchBar.text!, completion: { (movies, shows) in
            self.movies = movies
            self.shows = shows
            self.tableView.reloadData()
        })
    }
    
    
    func searchAPI(title: String, completion: @escaping ([Movie], [Show]) -> Void){
        
        let params: [String: Any] = [
            "title": title,
            "order": "popularity",
            "nbpp": 10
        ]

        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-BetaSeries-Key": "ef873e84f313",
            "X-BetaSeries-Version": "3.0"
        ]
        
        _ = Alamofire.request("https://api.betaseries.com/movies/search", method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (res: DataResponse<Any>) in
            guard let   jsonResponse = res.result.value as? [String:Any],
                let movie = jsonResponse["movies"] as? [[String:Any]] else{
                    //Todo : Cellule avec "aucun résultat"
                    return
            }
            var j = 0
            print(res)
            for _ in movie {
                //self.movies.append(Movie(id: movie[j]["id"] as! Int, title: movie[j]["title"] as! String, production_year: movie[j]["production_year"] as! Int))
                self.movies.append(Movie(id: movie[j]["id"] as! Int, title: movie[j]["title"] as! String, production_year: movie[j]["production_year"] as! Int, length: movie[j]["length"] as! Int, picture: movie[j]["poster"] as! String))
                //print(movies[j])
                j += 1
            }
            print(self.movies)
            
            _ = Alamofire.request("https://api.betaseries.com/shows/search", method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (res: DataResponse<Any>) in
                guard let   jsonResponse = res.result.value as? [String:Any],
                    let show = jsonResponse["shows"] as? [[String:Any]] else{
                        //Todo : Cellule avec "aucun résultat"
                        return
                }
                var i = 0
                for _ in show {
                    self.shows.append(Show(id: show[i]["id"] as! Int, title: show[i]["title"] as! String, seasons: show[i]["seasons"] as! String, episodes: show[i]["episodes"] as! String))
                    //print(shows[i])
                    i += 1
                }
                print(self.shows)
                
                completion(self.movies, self.shows)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel")
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }

}


extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UITableViewDataSource {
    
    public static let movieCellId = "MOVIE_SEARCH_CELL_IDENTIFIER"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return movies.count + shows.count
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movieCell = tableView.dequeueReusableCell(withIdentifier: SearchViewController.movieCellId, for: indexPath) as! MovieSearchTableViewCell
        let movie = self.movies[indexPath.row]
        movieCell.titleLabel.text = movie.title
        let imageURL = URL(string: movie.picture)
        let imageData = try! Data(contentsOf: imageURL!)
        movieCell.typeImageView.image = UIImage(data: imageData)
        movieCell.releaseDateLabel.text = "Sortie : " + String(movie.production_year)
        movieCell.lengthLabel.text = "Durée : " + String(movie.length/60) + " min"
        
        
        return movieCell
    }
}
