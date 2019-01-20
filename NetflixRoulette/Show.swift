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
        return " id: \(self.id), title: \(self.title), seasons: \(self.seasons), episodes: \(self.episodes)"
    }
    
    let id: Int
    let title: String
    let seasons: String
    let episodes: String
    
    convenience init? (json: [String: Any]){
        
        guard let id_show = json["id"] as? Int,
            let title_show = json["title"] as? String,
            let season_show = json["seasons"] as? String,
            let episode_show = json["episodes"] as? String else {
                return nil
        }
        self.init(id: id_show, title: title_show, seasons: season_show, episodes: episode_show)
    }
    
    init(id: Int, title: String, seasons: String, episodes: String) {
        self.id = id
        self.title = title
        self.seasons = seasons
        self.episodes = episodes
    }
    
    
}
