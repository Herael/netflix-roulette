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
    
}
