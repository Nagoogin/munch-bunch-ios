//
//  SignUpViewController.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/14/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldRepeatedPassword: UITextField!
    
    @IBAction func didTouchSignUp(_ sender: Any) {
        // TODO: add form validation and error handling
        let fname: String = textFieldFirstName.text!
        let lname: String = textFieldLastName.text!
        let email: String = textFieldEmail.text!
        let username: String = textFieldUsername.text!
        let password: String = textFieldPassword.text!
        let repeatedPassword: String = textFieldRepeatedPassword.text!
        
        if password != repeatedPassword {
            // Passwords don't match!
        } else {
            let parameters = [
                "username":username,
                "hash":password,
                "fname":fname,
                "lname":lname,
                "email":email,
                "hasTruck":false
            ] as [String : Any]
            
            Alamofire.request(SERVER_URL + "user", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                debugPrint(response)
                switch response.result {
                case .success:
                    print("User creation successful")
                // TODO: send a request to auth endpoint to get JWT for new user
                    self.performSegue(withIdentifier: "homeSegue", sender: sender)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @IBAction func didTouchCancel(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
