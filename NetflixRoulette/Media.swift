//
//  Media.swift
//  NetflixRoulette
//
//  Created by Benjamin Rousval on 13/02/2019.
//  Copyright © 2019 Ramzy Kermad. All rights reserved.
//

import Foundation
import Alamofire


public class Media : NSObject
{

    let id: Int
    let title: String
    let production_year: Int
    let picture: String
    
    convenience init? (json: [String: Any]){
        guard let id_media = json["id"] as? Int,
            let title_media = json["title"] as? String,
            let production_year_media = json["production_year"] as? Int,
            let picture_media = json["picture"] as? String else {
            return nil
        }
        self.init(id: id_media, title: title_media, production_year: production_year_media, picture: picture_media)
    }
    
    init(id: Int, title: String, production_year: Int, picture: String) {
        self.id = id
        self.title = title
        self.production_year = production_year
        self.picture = picture
    }
}

//Movie : Length
//Show : seasons, episodes
