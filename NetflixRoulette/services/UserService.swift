//
//  UserService.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 18/02/2019.
//  Copyright © 2019 Ramzy Kermad. All rights reserved.
//

import Foundation
import Alamofire

public class UserService{
    public static let `default` = UserService()
    
    private let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "X-BetaSeries-Key": "ef873e84f313",
        "X-BetaSeries-Version": "3.0"
    ]
    
    private init(){}
    
    func loginUser(login: String, password: String, completion: @escaping (Int, [String: Any])-> Void){
        
        let params: [String : Any] = [
            "login": login,
            "password": password
        ]
        
        _ = Alamofire.request("https://api.betaseries.com/members/auth", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (res: DataResponse<Any>) in
                guard let json_response = res.result.value as? [String: Any] else {
                    return
                }
                completion((res.response?.statusCode)!, json_response)

        }
    }
    
    func createAccount(login: String, email: String, password: String, completion: @escaping ()->Void){
        let params: [String: String] = [
            "login": login,
            "email": email,
            "password": password
        ]
        
        _ = Alamofire.request("https://api.betaseries.com/members/signup", method: .post, parameters: params, encoding: JSONEncoding.default , headers: headers).responseJSON { response in
            print("server response: \(response)")
            guard let json_res = response.result.value as? [String: Any],
                let user = json_res["user"] as? [String: Any],
                let user_login = user["login"] as? String,
                let user_id = user["id"] as? Int,
                let auth_token = json_res["token"] as? String else {
                    return
            }
            
            let new_user = User(id: user_id, login: user_login, token: auth_token)
            print("Account successfully created.")
            print("Account details: \(new_user)")
            completion()
        }
    }
}
