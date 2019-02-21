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
        self.fieldNotFilled.isHidden = hideSomeFieldsEmptyWarning   // hide the warning
        self.differentPasswordField.isHidden = hidePasswordsAreDifferentWarning //hide the warning
        
        hideSomeFieldsEmptyWarning = !hideSomeFieldsEmptyWarning //false
        hidePasswordsAreDifferentWarning = !hidePasswordsAreDifferentWarning //false
        
        self.hideKeyboardWhenTappedAround()
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
        UserService.default.createAccount(login: self.login_field.text!, email: self.email_field.text!, password: self.toMD5encryption(password: self.init_password_field.text!)) {
            let back = MainViewController()
            self.navigationController?.pushViewController(back, animated: true)
        }
    }
    
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
