//
//  MovieServices.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 09/02/2019.
//  Copyright © 2019 Ramzy Kermad. All rights reserved.
//

import Foundation
import Alamofire

class FavMovieServices{
    
    public static let `default` = FavMovieServices()
    
    private let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "X-BetaSeries-Key": "ef873e84f313",
        "X-BetaSeries-Version": "3.0"
    ]
    
    private init(){
        
    }
    
    public func addMovieToFavs(movieID: Int, userAuthToken: String){
        // Alamofire add movie to favorit list movies of the user
        let params: [String: Any] = [
            "id": movieID,
            "token": userAuthToken
        ]
        
        _ = Alamofire.request("https://api.betaseries.com/movies/favorite", method: .post, parameters: params, encoding: JSONEncoding.default, headers: self.headers).responseJSON(completionHandler: { response in
            guard let json_result = response.result.value as? [String: Any] else{
                return
            }
            print("Response: -----------------> \(json_result)")
        })
    }
    
    public func deleteMovieFromFavorite(movieID: Int, userAuthToken: String){
        // Alamofire delete movie from favorit list movies of the user
        let params: [String: Any] = [
            "id": movieID,
            "token": userAuthToken
        ]
        
        _ = Alamofire.request("https://api.betaseries.com/movies/favorite", method: .delete, parameters: params, encoding: JSONEncoding.default, headers: self.headers).responseJSON(completionHandler: { response in
            guard let json_result = response.result.value as? [String: Any] else{
                return
            }
            print("Response: -----------------> \(json_result)")
        })
    }
    
    public func getFavsMovies(userId: Int, completion: @escaping ([Movie?]) -> Void){
        // Alamofire add movie to favorit list movies of the user
        
        let params: [String: Any] = [
            "id": userId
        ]
        
        var favsList: [Movie] = []
        var currentResponseElement: [String: Any] = [:]
        
        _ = Alamofire.request("https://api.betaseries.com/movies/favorites", method: .get, parameters: params, encoding: JSONEncoding.default, headers: self.headers).responseJSON { response in
            
            guard let json_response = response.result.value as? [String: Any],
                    let favorite_movies = json_response["movies"] as? [[String: Any]] else{
                    return
            }
            var movieId: Int
            var movieTitle: String
            var prodYear: Int
            var movieLength: Int
            var moviePicture: String
            
            var currentMovie: Movie
            
            for i in 0..<favorite_movies.count{
                currentResponseElement = favorite_movies[i]
                
                movieId = currentResponseElement["id"] as! Int
                movieTitle = currentResponseElement["title"] as! String
                prodYear = Int(currentResponseElement["production_year"] as! String)!
                movieLength = Int(currentResponseElement["length"] as! String)!
                moviePicture = currentResponseElement["poster"] as! String
                
                currentMovie = Movie(id: movieId, title: movieTitle, production_year: prodYear, length: movieLength, picture: moviePicture)
                favsList.append(currentMovie)
            }
            
            completion(favsList)
        }
    }
}
