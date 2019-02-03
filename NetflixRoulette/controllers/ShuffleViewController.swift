//
//  ShuffleViewController.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 22/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import UIKit
import Alamofire

class ShuffleViewController: UIViewController {

    @IBOutlet weak var randomBox: UIImageView!
    @IBOutlet weak var movie_radioButton: UISwitch!
    @IBOutlet weak var series_radioButton: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ShuffleViewController.tapDetected))
        randomBox.isUserInteractionEnabled = true
        randomBox.addGestureRecognizer(singleTap)
    }
    

    @objc func tapDetected() {
        let random_number = Int.random(in: 1...10)
        let params: [String : Any] = [
            "nb": random_number
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-BetaSeries-Key": "ef873e84f313",
            "X-BetaSeries-Version": "3.0"
        ]
        let showShuffleResult = ShuffleResultListViewController()
        
        if movie_radioButton.isOn && !series_radioButton.isOn{  // Only movies
            print("You'll have between 1 & 10 elements with only movies")
            getMovies(nb: random_number, params: params, headers: headers, completion: { res in
                showShuffleResult.movies = res
                self.navigationController?.pushViewController(showShuffleResult, animated: true)
            })
        } else if !movie_radioButton.isOn && series_radioButton.isOn{    // Only series
            print("You'll have between 1 & 10 elements with only series")
            getSeries(nb: random_number, headers: headers, completion: { res in
                showShuffleResult.movies = res
                self.navigationController?.pushViewController(showShuffleResult, animated: true)
            })
        } else if movie_radioButton.isOn && series_radioButton.isOn{     // mix movies/series
            print("You'll have between 1 & 10 elements with mix of movies & series")
            getMovies(nb: random_number, params: params, headers: headers, completion: { res in
                showShuffleResult.movies = res
                self.navigationController?.pushViewController(showShuffleResult, animated: true)
            })
        } else {     // nothing ----> show message error
            print("You must check at least one radio button")
        }
        
    }
    
    
    func getMovies(nb: Int, params: [String : Any], headers: HTTPHeaders, completion: @escaping ([Movie])-> Void){
        var moviz: [Movie] = []
        
        _ = Alamofire.request("https://api.betaseries.com/movies/random", method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response: DataResponse<Any>) in
            guard let json_response = response.result.value as? [String: Any],
                let movie_description = json_response["movies"] as? [Any] else{
                    return
            }
            var current_movie: [String: Any]
            
            var poster_url: String?
            var title_movie: String?
            var year_prod: Int
            var length: Int = 0
            var id: Int
            
            for count in 0..<nb{
                current_movie = movie_description[count] as! [String: Any]
                
                title_movie = current_movie["title"] as? String
                year_prod = current_movie["production_year"] as! Int
                id = current_movie["id"] as! Int
                poster_url = current_movie["poster"] as? String
                length = current_movie["length"] as! Int
            
                
                moviz.append(Movie(id: id, title: title_movie!, production_year: year_prod, length: length, picture: poster_url ?? "no url"))
            }
            
            if nb < 10 && (self.series_radioButton.isOn && self.movie_radioButton.isOn){
                self.getSeries(nb: 10 - nb, headers: headers, completion: { res in
                    for i in 0..<res.count{
                        moviz.append(res[i])
                    }
                    completion(moviz)
                })
            }else{
                completion(moviz)
            }
            
            for i in 0..<nb{
                print("Movie n° \(i+1) ------> \(moviz[i])")
            }
        }
        
    }
    
    
    func getSeries(nb: Int, headers: HTTPHeaders, completion: @escaping ([Movie])-> Void){
        let params: [String: Any] = [
            "nb": nb
        ]
        
        var showz: [Movie] = []
        
        _ = Alamofire.request("https://api.betaseries.com/shows/random", method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response: DataResponse<Any>) in
            guard let json_response = response.result.value as? [String: Any],
                let show_description = json_response["shows"] as? [Any] else{
                    return
            }
            var current_movie: [String: Any]
            
            var poster_url: String?
            var show_links: [String: Any]
            var title_movie: String?
            var year_prod: String = "0"
            var length: String = "0"
            var id: Int
            
            for count in 0..<nb{
                current_movie = show_description[count] as! [String: Any]
                title_movie = current_movie["title"] as? String
                
                if current_movie["creation"] != nil{
                    year_prod = current_movie["creation"] as! String
                }
                
                id = current_movie["id"] as! Int
                show_links = current_movie["images"] as! [String: Any]
                length = current_movie["length"] as! String
                poster_url = show_links["show"] as? String
                
                if poster_url == nil{
                    poster_url = show_links["baner"] as? String
                    if poster_url == nil{
                        poster_url = show_links["box"] as? String
                        if poster_url == nil{
                            poster_url = show_links["poster"] as? String
                        }
                    }
                }
                showz.append(Movie(id: id, title: title_movie!, production_year: Int(year_prod)!,length: Int(length)! * 60, picture: poster_url ?? "default"))
            }
            
            print()
            for i in 0..<nb{
                print("Show  n° \(i+1) ------> \(showz[i])")
            }
            completion(showz)
        }
    }
    
}
