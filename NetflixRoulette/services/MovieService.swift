//
//  MovieService.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 17/02/2019.
//  Copyright © 2019 Ramzy Kermad. All rights reserved.
//

import Foundation
import Alamofire

public class MovieService{
    public static let `default` = MovieService()
    
    private let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "X-BetaSeries-Key": "ef873e84f313",
        "X-BetaSeries-Version": "3.0"
    ]
    
    private init(){
        
    }
    
    func getMovieFromId(idMovie: Int, completion: @escaping ( DataResponse<Any>)->Void){
        let params: [String : Int] = [
            "id": idMovie
        ]
        _ = Alamofire.request("https://api.betaseries.com/movies/movie", method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response: DataResponse<Any>) in
            
            completion(response)
        }
    }
    
    func getHomeRandomMovie(completion: @escaping (String, String, Int) -> Void){
        let params: [String : Any] = [
            "nb": 1
        ]
        _ = Alamofire.request("https://api.betaseries.com/movies/random", method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response: DataResponse<Any>) in
            print(response)
            
            guard let json_response = response.result.value as? [String: Any],
                let movie_description = json_response["movies"] as? [Any],
                let random_movie = movie_description[0] as? [String: Any],
                let random_title = random_movie["title"] as? String,
                let random_id = random_movie["id"] as? Int,
                let random_poster_url = random_movie["poster"] as? String else{
                    return
            }
            completion(random_title, random_poster_url, random_id)
        }
    }
    
    func getMovieByTitle(title: String, completion: @escaping ([Movie], [Show]) -> Void){
        let params: [String: Any] = [
            "title": title,
            "order": "popularity",
            "nbpp": 10
        ]
        
        var movies_list: [Movie] = []
        
        _ = Alamofire.request("https://api.betaseries.com/movies/search", method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (res: DataResponse<Any>) in
            guard let   jsonResponse = res.result.value as? [String:Any],
                let movie = jsonResponse["movies"] as? [[String:Any]] else{
                    //Todo : Cellule avec "aucun résultat"
                    return
            }
            
            for j in 0..<movie.count {
                movies_list.append(Movie(id: movie[j]["id"] as! Int, title: movie[j]["title"] as! String, production_year: movie[j]["production_year"] as! Int, length: movie[j]["length"] as! Int, picture: movie[j]["poster"] as! String))
            }
            
            self.getShowByTitle(params: params, headers: self.headers, completion: { show_result in
                completion(movies_list, show_result)
            })
        }
        
    }
    
    func getShowByTitle(params: [String: Any], headers: HTTPHeaders, completion: @escaping ([Show]) -> Void){
        
        var shows: [Show] = []
        
        _ = Alamofire.request("https://api.betaseries.com/shows/search", method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (res: DataResponse<Any>) in
            
            guard let   jsonResponse = res.result.value as? [String:Any],
                let show = jsonResponse["shows"] as? [[String:Any]] else{
                    //Todo : Cellule avec "aucun résultat"
                    return
            }
            
            for i in 0..<show.count {
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
                
                shows.append(Show(id: show[i]["id"] as! Int, title: show[i]["title"] as! String, production_year: myInt, seasons: show[i]["seasons"] as! String, episodes: show[i]["episodes"] as! String, picture: poster_url!))
            }
            
            completion(shows)
        }
    }
}
