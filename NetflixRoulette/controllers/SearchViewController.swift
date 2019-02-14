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
    var medias: [Media] = []
    
    
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
        self.tableView.register(UINib(nibName: "MovieSearchTableViewCell", bundle: nil), forCellReuseIdentifier: SearchViewController.mediaCellId)
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: nil)
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
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.movies.removeAll()
        self.shows.removeAll()
        self.medias.removeAll()
        self.tableView.reloadData()
    }
    
    
    func searchAPI(title: String, completion: @escaping ([Movie], [Show]) -> Void){
        
        self.movies.removeAll()
        self.shows.removeAll()
        self.medias.removeAll()
        
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
            //print(res)
            for _ in movie {
                self.movies.append(Movie(id: movie[j]["id"] as! Int, title: movie[j]["title"] as! String, production_year: movie[j]["production_year"] as! Int, length: movie[j]["length"] as! Int, picture: movie[j]["poster"] as! String))
                self.medias.append(self.movies[j])
                j += 1
            }
            //print(self.movies)
            
            _ = Alamofire.request("https://api.betaseries.com/shows/search", method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (res: DataResponse<Any>) in
                guard let   jsonResponse = res.result.value as? [String:Any],
                    let show = jsonResponse["shows"] as? [[String:Any]] else{
                        //Todo : Cellule avec "aucun résultat"
                        return
                }
                var i = 0
                for _ in show {
                    let temp_creation = show[i]["creation"] as! String
                    let myInt = (temp_creation as NSString).integerValue
                    let images = show[i]["images"] as! [String: Any]
                    var poster_url = images["poster"] as? String
                    if poster_url == nil{
                        poster_url = images["baner"] as? String
                        if poster_url == nil{
                            poster_url = images["box"] as? String
                            if poster_url == nil{
                                poster_url = images["show"] as? String
                            }
                        }
                    }
                    

                    self.shows.append(Show(id: show[i]["id"] as! Int, title: show[i]["title"] as! String, production_year: myInt, seasons: show[i]["seasons"] as! String, episodes: show[i]["episodes"] as! String, picture: poster_url!))
                    self.medias.append(self.shows[i])
                    i += 1
                }
                //print(self.shows)
                
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
    
    public static let mediaCellId = "MOVIE_SEARCH_CELL_IDENTIFIER"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mediaCell = tableView.dequeueReusableCell(withIdentifier: SearchViewController.mediaCellId, for: indexPath) as! MovieSearchTableViewCell
        let media = self.medias[indexPath.row]
        mediaCell.titleLabel.text = media.title
        
        if media.picture.description != ""{
            let imageURL = URL(string: media.picture)
            let imageData = try! Data(contentsOf: imageURL!)
            mediaCell.typeImageView.image = UIImage(data: imageData)
        }
        if media.isKind(of: Movie.self) {
            
            mediaCell.releaseDateLabel.text = "Sortie : " + String(media.production_year)
            mediaCell.lengthLabel.text = "Durée : " + String((media as! Movie).length/60) + " min"
        }else if media.isKind(of: Show.self) {
            
            mediaCell.releaseDateLabel.text = "Sortie : " + String(media.production_year)
            mediaCell.lengthLabel.text = "Saison : " + (media as! Show).seasons
        }
        
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.red
        mediaCell.selectedBackgroundView = backgroundView
        
        return mediaCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let item_description = ItemDescriptionViewController()
        item_description.movie_title = self.medias[indexPath.row].title
        item_description.movie_id = self.medias[indexPath.row].id
        item_description.movie_image_url = self.medias[indexPath.row].picture
        self.navigationController?.pushViewController(item_description, animated: true)
    }
    
}


//typeof()
