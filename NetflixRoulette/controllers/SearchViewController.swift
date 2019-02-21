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
    @IBOutlet weak var noResultLabel: UILabel!
    
    
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
        self.noResultLabel.isHidden = true
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
        self.searchAPI(title: searchBar.text!, completion: { (movie_list, show_list) in
            self.medias.append(contentsOf: movie_list)
            self.medias.append(contentsOf: show_list)
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
        
        MovieService.default.getMovieByTitle(title: title) { (movies_list, shows_list) in
            if movies_list.count == 0 && shows_list.count == 0{
                self.movies.removeAll()
                self.shows.removeAll()
                self.medias.removeAll()
                self.tableView.reloadData()
                self.noResultLabel.isHidden = false
            }else{
                self.noResultLabel.isHidden = true
                completion(movies_list, shows_list)
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
        self.noResultLabel.isHidden = true
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
        
        if media.picture.description != "" {
            let imageURL = URL(string: media.picture)
            let imageData = try! Data(contentsOf: imageURL!)
            mediaCell.typeImageView.image = UIImage(data: imageData)
        }else {
            mediaCell.typeImageView.image = UIImage(named: "noPicture")
        }
        
        
        if media.isKind(of: Movie.self) {
            
            mediaCell.releaseDateLabel.text = "Date : " + String(media.production_year)
            mediaCell.lengthLabel.text = "Length : " + String((media as! Movie).length/60) + " min"
        }else if media.isKind(of: Show.self) {
            
            mediaCell.releaseDateLabel.text = "Date : " + String(media.production_year)
            mediaCell.lengthLabel.text = "Seasons : " + (media as! Show).seasons
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
