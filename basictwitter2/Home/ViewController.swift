//
//  ViewController.swift
//  basictwitter2
//
//  Created by Carlos Mata on 8/22/18.
//  Copyright © 2018 Carlos Mata Fernandez. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var messages = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        tableView.dataSource = self
        title = PFUser.current()?.username
        getMessages()
    }
    
    func getMessages() {
       
        let query = PFQuery(className: "Messages")
        query.findObjectsInBackground { (objects, error) in
            
            if let objects = objects{
                
                print(objects[0])
                self.messages = objects
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        
        let alert = UIAlertController(title: "Do you want to logout?", message: "Click cancel to remain in the app", preferredStyle: .alert)
       
        let logoutAction = UIAlertAction(title: "Logout", style: .default) { (action) in
            PFUser.logOut()
            Helper.shared.switchStoryboard(storyboardName: "login", identifier: "login")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as!  MessagesTableViewCell
        
        let messageObj = messages[indexPath.row]
        
        let sender = messageObj["sender"] as? String ?? ""
        let message = messageObj["message"] as? String ?? ""
        
        let likes = messageObj["likes"] as? [String] ?? [String]()
        
        let comments = messageObj["comments"] as? [String] ?? [String]()
        
        
        cell.usernameLabel.text = sender
        cell.messageLabel.text = message
        
        cell.likeButton.setTitle("\(likes.count) likes", for: .normal)
        cell.commentsButton.setTitle("\(comments.count) comments", for: .normal)
        
        //set up like button click
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeCliked(sender:)), for: .touchUpInside)
        
        //set up comment button click
        cell.commentsButton.tag = indexPath.row
        cell.commentsButton.addTarget(self, action: #selector(commentsClicked), for: .touchUpInside)
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    @objc func likeCliked(sender: UIButton){
        
        let messageObj = messages[sender.tag]
        let currentUsername = PFUser.current()?.username!
        let sender = messageObj["sender"] as? String ?? ""
        var likesArray = messageObj["likes"] as? [String] ?? [String]()
        
        if sender == currentUsername{
            
            Helper.shared.showAlert(title: "Not allowed", message: "You are not allowed to like your own message.", viewController: self)
            return
        }
        
        if likesArray.contains(currentUsername!){
            
            Helper.shared.showAlert(title: "Not allowed", message: "You can not like a message multiple times.", viewController: self)
            return
        }
        
        likesArray.append(currentUsername!)
        messageObj["likes"] = likesArray
        messageObj.saveInBackground { (suceed, error) in
            
            self.tableView.reloadData()
        }
        
        
    }
    @objc func commentsClicked(sender: UIButton){
        
        print(sender.tag)
    }
}
