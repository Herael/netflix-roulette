//
//  CreateAccountViewController.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 24/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import UIKit
import Alamofire
import CommonCrypto

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var email_field: UITextField!
    @IBOutlet weak var login_field: UITextField!
    
    @IBOutlet weak var init_password_field: UITextField!
    @IBOutlet weak var second_password_field: UITextField!
    
    @IBOutlet weak var fieldNotFilled: UILabel!
    @IBOutlet weak var differentPasswordField: UILabel!
    
    var hideSomeFieldsEmptyWarning = true
    var hidePasswordsAreDifferentWarning = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.fieldNotFilled.isHidden = hideSomeFieldsEmptyWarning   // hide the warning
        self.differentPasswordField.isHidden = hidePasswordsAreDifferentWarning //hide the warning
        
        hideSomeFieldsEmptyWarning = !hideSomeFieldsEmptyWarning //false
        hidePasswordsAreDifferentWarning = !hidePasswordsAreDifferentWarning //false
    }

    @IBAction func createAccount(_ sender: Any) {
        checkFieldsFilled()
        
    }
    
    func checkFieldsFilled(){
        if self.email_field.text != ""
            && self.init_password_field.text != ""
            && self.second_password_field.text != ""
            && self.login_field.text != ""
        {
            self.fieldNotFilled.isHidden = true
            if self.init_password_field.text != self.second_password_field.text{
                self.differentPasswordField.isHidden = false
            }else{
                self.differentPasswordField.isHidden = true
                postAccount()
            }
        } else {
             self.fieldNotFilled.isHidden = false
        }
    }
    
    func postAccount(){
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-BetaSeries-Key": "ef873e84f313",
            "X-BetaSeries-Version": "3.0"
        ]
        let params: [String: String] = [
            "login": self.login_field.text!,
            "email": self.email_field.text!,
            "password": self.toMD5encryption(password: self.init_password_field.text!)
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
            
        }
        
        //TODO: delete these 2 lines of code (just for a test)
        let back = MainViewController()
        self.navigationController?.pushViewController(back, animated: true)
    }
    
    // OK
    // Func to encrypt the password of the user with MD5 & send it in JSON obj
    func toMD5encryption(password: String) -> String {
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, password, CC_LONG(password.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate()
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        
        return hexString
    }
}
