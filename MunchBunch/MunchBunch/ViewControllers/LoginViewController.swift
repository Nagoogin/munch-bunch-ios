//
//  LoginViewController.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/14/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBAction func didTouchLogin(_ sender: Any) {
        // TODO: add form validation and error handling
        let username: String = textFieldUsername.text!
        let password: String = textFieldPassword.text!
        
        let parameters = [
            "username":username,
            "password":password
        ]
        
        Alamofire.request(SERVER_URL + "auth/authenticate", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let data):
                print("Auth successful")
                // Convert json response to a dictionary
                if let json = data as? [String : AnyObject] {
                    if let token = json["data"]!["token"] as? String {
                        // Save returned JWT to UserDefaults
                        self.defaults.set(token, forKey: "token")
                        // Segue to HomeViewController
                        self.performSegue(withIdentifier: "loginSegue", sender: sender)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func didTouchSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "signUpSegue", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

