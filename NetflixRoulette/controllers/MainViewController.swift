//
//  MainViewController.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 19/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import UIKit
import Alamofire
import CommonCrypto

class MainViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var user_email: UITextField!
    @IBOutlet weak var user_password: UITextField!
    
    @IBOutlet weak var fieldsErrorWarning: UILabel! // Error message if email or password are wrong
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign in"
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.fieldsErrorWarning.isHidden = true
        self.hideKeyboardWhenTappedAround()
    }

    
    @IBAction func sign(_ sender: Any) {
        self.addToApi(completion: { (success, user) in
            if success == true {
                let home = HomeViewController()
                self.navigationController?.pushViewController(home, animated: true)
            }else{
                self.fieldsErrorWarning.isHidden = false
                print("Error while signing in!")
            }
        })
    }
    
    func addToApi(completion: @escaping (Bool, User) -> Void){
        guard let email = user_email.text,
              let pwd = user_password.text else {
            return
        }
        
        let params: [String : Any] = [
            "login": email,
            "password": self.toMD5encryption(password: pwd)
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-BetaSeries-Key": "ef873e84f313",
            "X-BetaSeries-Version": "3.0"
        ]
        _ = Alamofire.request("https://api.betaseries.com/members/auth", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (res: DataResponse<Any>) in
            if res.response?.statusCode == 200{
                guard let json_response = res.result.value as? [String: Any] else {
                    return
                }
                let user: User = User(json: json_response)!
                print(user)
                completion(res.response?.statusCode == 200, user)
            } else {
                print("User doesn't exist!!!!!!!!")
            }
        }
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
    
    @IBAction func sign_up(_ sender: Any) {
        let create_account_vc = CreateAccountViewController()
        self.navigationController?.pushViewController(create_account_vc, animated: true)
    }
    
}

// Extension to allow hidding the keyboard if the user clicks anywhere else in the view

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
