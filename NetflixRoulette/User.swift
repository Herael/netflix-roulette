//
//  User.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 25/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import Foundation
import Alamofire

class User: NSObject{
    
    override var description: String{
        return "id_user: \(self.id), login user: \(self.login), auth_token: \(self.token)"
    }
    
    let id: Int
    let login: String
    let token: String
    
    convenience init? (json: [String: Any]){
        guard let user_response = json["user"] as? [String: Any],
                let user_id = user_response["id"] as? Int,
                let user_login = user_response["login"] as? String,
             let token_response = json["token"] as? String else {
                return nil
        }
        self.init(id: user_id, login: user_login, token: token_response)
    }
    
     init(id: Int, login: String, token: String){
        self.id = id
        self.login = login
        self.token = token
    }
    
    
}
