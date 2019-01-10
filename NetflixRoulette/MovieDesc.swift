//
//  MovieDesc.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 24/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import Foundation
import Alamofire

class  Movie: NSObject {
    
    override var description: String{
        return " id: \(self.id), title: \(self.title), prod year: \(self.production_year)"
    }
    
    let id: Int
    let title: String
    let production_year: String
    let season: Int?
    let episode: Int?
    
    convenience init? (json: [String: Any]){
        
        guard let id_movie = json["id"] as? Int,
              let title_movie = json["title"] as? String,
              let production_year = json["production_year"] as? String,
              let season_show = json["season"] as? Int?,
              let episode_show = json["episode"] as? Int? else {
                return nil
        }
        self.init(id: id_movie, title: title_movie, production_year: production_year, season: season_show, episode: episode_show)
    }
    
    init(id: Int, title: String, production_year: String, season: Int?, episode: Int?) {
        self.id = id
        self.title = title
        self.production_year = production_year
        self.season = season
        self.episode = episode
    }
    
    
}
