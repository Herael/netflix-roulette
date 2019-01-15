//
//  Show.swift
//  NetflixRoulette
//
//  Created by Benjamin Rousval on 10/01/2019.
//  Copyright © 2019 Ramzy Kermad. All rights reserved.
//

import Foundation
import Alamofire

public class Show : NSObject {
    
    override public var description: String{
        return " id: \(self.id), title: \(self.title), prod year: \(self.production_year), season: \(self.season), episode: \(self.season)"
    }
    
    let id: Int
    let title: String
    let production_year: Int
    let season: Int
    let episode: Int
    
    convenience init? (json: [String: Any]){
        
        guard let id_show = json["id"] as? Int,
            let title_show = json["title"] as? String,
            let production_year = json["production_year"] as? Int,
            let season_show = json["season"] as? Int,
            let episode_show = json["episode"] as? Int else {
                return nil
        }
        self.init(id: id_show, title: title_show, production_year: production_year, season: season_show, episode: episode_show)
    }
    
    init(id: Int, title: String, production_year: Int, season: Int, episode: Int) {
        self.id = id
        self.title = title
        self.production_year = production_year
        self.season = season
        self.episode = episode
    }
    
    
}
