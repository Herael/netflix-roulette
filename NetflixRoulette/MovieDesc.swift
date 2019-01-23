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
        return " id: \(self.id), title: \(self.title), prod year: \(self.production_year), length: \(self.length)"
    }
    
    let id: Int
    let title: String
    let production_year: Int
    let length: Int
    let picture: String
    
    convenience init? (json: [String: Any]){
        
        guard let id_movie = json["id"] as? Int,
              let title_movie = json["title"] as? String,
              let production_year = json["production_year"] as? Int,
              let length_movie = json["length"] as? Int,
              let picture_movie = json["picture"] as? String else {
                return nil
        }
        self.init(id: id_movie, title: title_movie, production_year: production_year, length: length_movie, picture: picture_movie)
    }
    
    init(id: Int, title: String, production_year: Int, length: Int, picture: String) {
        self.id = id
        self.title = title
        self.production_year = production_year
        self.length = length
        self.picture = picture
    }
    
    
}
