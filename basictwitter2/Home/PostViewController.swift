//
//  PostViewController.swift
//  basictwitter2
//
//  Created by Carlos Mata on 9/1/18.
//  Copyright © 2018 Carlos Mata Fernandez. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController {

    @IBOutlet weak var messageTextview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func close(_ sender: Any) {
    
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func post(_ sender: Any) {
       
        if messageTextview.text.characters.count == 0 {
            Helper.shared.showAlert(title: "Required", message: "Escribe algo", viewController: self)
            
            return 
        }  
        let messageObj = PFObject(className: "Messages")
        messageObj["sender"] = PFUser.current()?.username!
        messageObj["message"] = messageTextview.text
        messageObj["likes"] = [String]()
        messageObj["comments"] = [String]()
        messageObj["flagged"] = 0
        
        messageObj.saveInBackground { (succed, error) in
            
            self.messageTextview.text = ""
            Helper.shared.showAlert(title: "Shared", message: "se ha compartio", viewController: self)
        }
    }
}
