//
//  MovieDesc.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 24/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import Foundation
import Alamofire

class  Movie: Media {
    
    override var description: String{
        return " id: \(self.id), title: \(self.title), prod year: \(self.production_year), length: \(self.length)"
    }
    
    let length: Int
    
    init(id: Int, title: String, production_year: Int, length: Int, picture: String) {
        self.length = length
        super.init(id: id, title: title, production_year: production_year, picture: picture)
    }
    
//    override var description: String{
//        return " id: \(self.id), title: \(self.title), prod year: \(self.production_year), length: \(self.length)"
//    }
//    convenience init? (json: [String: Any]){
//
//        guard let length_movie = json["length"] as? Int else {
//                return nil
//        }
//        self.init(length: length_movie)
//    }
    
//    init(id: Int, title: String, production_year: Int, picture: String, length: Int) {
//        self.length = length
//    }
}
