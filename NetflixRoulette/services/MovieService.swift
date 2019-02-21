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

    func getBestPopularMovies(completion: @escaping ([[String]]) -> Void){
        let params: [String : Any] = [
            "type": "popular",
            "limit": 4
        ]
        
        self.getuUpcomingMovies(url: "https://api.betaseries.com/movies/discover", params: params) { (movies) in
            completion(movies)
        }
    }
    
    
    func getPopularUpcomingMovies(completion: @escaping ([[String]]) -> Void){
        // Modifier les params (order: popularity ou release_date)
        let params: [String : Any] = [
            "limit": 4,
            "order": "popularity"
        ]
        
        self.getuUpcomingMovies(url: "https://api.betaseries.com/movies/upcoming", params: params) { (movies) in
            completion(movies)
        }
    }
    
    
    func getuUpcomingMovies(url: String, params: [String: Any], completion: @escaping ([[String]]) -> Void){
        
        var moviesDictionnary: [[String]] = []
        
        _ = Alamofire.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (res: DataResponse<Any>) in
            
            guard let response_json = res.result.value as? [String: Any],
                let popular_movies = response_json["movies"] as? [[String: Any]] else{
                    return
            }
            
            var movie_title: String
            var movie_id: String
            
            for count in 0..<popular_movies.count{
                if let id = popular_movies[count]["id"] as? String{
                    movie_id = id
                }else{
                    movie_id = (popular_movies[count]["id"] as! Int).description
                }
                
                movie_title = popular_movies[count]["title"] as! String
                
                moviesDictionnary.append([movie_id.description, movie_title, ""])
            }
            
            
            self.getMoviesPoster(moviesList: moviesDictionnary, completion: { (posters) in
                var currentMovieId: String
                for i in 0..<popular_movies.count {
                    
                    currentMovieId = moviesDictionnary[i][0]
                    moviesDictionnary[i][2] = posters[currentMovieId] as! String
                }
                completion(moviesDictionnary)
            })
            
        }
    }
    
    
    func getMoviesPoster(moviesList: [[String]], completion: @escaping ([String: Any]) -> Void){
        var resulTab: [String: Any] = [:]
        
        for i in 0..<4{
            let params: [String: Any] = [
                "title": moviesList[i][1]
            ]
            _ = Alamofire.request("https://api.betaseries.com/movies/search", method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (res: DataResponse<Any>) in
                
                guard let jsonResponse = res.result.value as? [String:Any],
                    let movie = jsonResponse["movies"] as? [[String:Any]],
                    let movie_poster = movie[0]["poster"] as? String,
                    let movie_id = movie[0]["id"] as? Int
                else{
                        return
                }
                
                resulTab[movie_id.description] = movie_poster
                if(resulTab.count == 4){
                    completion(resulTab)
                }
            }
        }
    }
    
    
}
