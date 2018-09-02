//
//  RegisterViewController.swift
//  basictwitter2
//
//  Created by Carlos Mata on 8/29/18.
//  Copyright © 2018 Carlos Mata Fernandez. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTf: UITextField!
    
    @IBOutlet weak var passwordTf: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func register(_ sender: Any) {

        guard let username = usernameTf.text, let password = passwordTf.text else { return }

        let user = PFUser()
        user.username = username.lowercased()
        user.password = password
        
        user.signUpInBackground { (suceed, error) in
            
            if suceed == true {
                
                Helper.shared.switchStoryboard(storyboardName: "Main", identifier: "home")
            } else {
                let localised = (error?.localizedDescription)!
                
                Helper.shared.showAlert(title: "Error", message: localised, viewController: self)
            }
        }
    }
    

    @IBAction func close(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
