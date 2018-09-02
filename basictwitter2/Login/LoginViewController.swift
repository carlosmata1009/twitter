//
//  LoginViewController.swift
//  basictwitter2
//
//  Created by Carlos Mata on 8/29/18.
//  Copyright © 2018 Carlos Mata Fernandez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: Any) {
    
        guard let username = usernameTf.text, let password = passwordTf.text else { return }
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            
            if error == nil {
                
                Helper.shared.switchStoryboard(storyboardName: "Main", identifier: "home")
            } else {
                
                Helper.shared.showAlert(title: "Error", message: (error?.localizedDescription)!, viewController: self)
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
