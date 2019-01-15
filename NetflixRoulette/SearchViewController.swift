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
    
    var shows: [Movie]?
    var movies: [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.becomeFirstResponder()
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).keyboardAppearance = .dark
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        guard (searchBar.text) != nil else{
            return
        }
        self.searchAPI(title: searchBar.text!, completion: { (succes) in
            print(succes)
        })
    }
    
    func searchAPI(title: String, completion: @escaping (Bool) -> Void){
        
        var movies : [Movie] = []
        var shows : [Show] = []
        
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
            var i = 0
            for _ in movie {
                
                movies.append(Movie(id: movie[i]["id"] as! Int, title: movie[i]["title"] as! String, production_year: movie[i]["production_year"] as! Int))
                //print(movies[i])
                i = i + 1
            }
            i = 0
            print(movies)
            }
        
//        _ = Alamofire.request("https://api.betaseries.com/shows/search", method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (res: DataResponse<Any>) in
//            guard let   jsonResponse = res.result.value as? [String:Any],
//                let show = jsonResponse["shows"] as? [[String:Any]] else{
//                    //Todo : Cellule avec "aucun résultat"
//                    return
//            }
//            for _ in show {
//                var i = 0
//                print(show)
//                shows.append(Show(id: show[i]["id"] as! Int, title: show[i]["title"] as! String, production_year: show[i]["production_year"] as! Int, season: show[i]["season"] as! Int, episode: show[i]["episode"] as! Int))
//                print(shows[i])
//                i = i + 1
//            }
//            print(shows)
//        }
        
        
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
