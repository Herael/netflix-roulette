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

    @IBAction func sign_up(_ sender: Any) {
        let create_account_vc = CreateAccountViewController()
        self.navigationController?.pushViewController(create_account_vc, animated: true)
    }
    
    @IBAction func sign(_ sender: Any) {
        self.addToApi(completion: { (success, user) in
            if success == 200 {
                let home = HomeViewController()
                home.userLogin = user.login
                home.userId = user.id
                home.userAuthToken = user.token
                self.navigationController?.pushViewController(home, animated: true)
            }else{
                self.fieldsErrorWarning.isHidden = false
                print("Error while signing in!")
            }
        })
    }
    
    func addToApi(completion: @escaping (Int, User) -> Void){
        guard let email = user_email.text,
              let pwd = user_password.text else {
            return
        }
        UserService.default.loginUser(login: email, password: self.toMD5encryption(password: pwd), completion: { (statusCode, response) in
            if statusCode != 200{
                self.fieldsErrorWarning.isHidden = false
                print("Error while signing in!")
            } else {
                let user: User = User(json: response)!
                print("User logger: \(user)")
                completion(200, user)
            }
        })
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
