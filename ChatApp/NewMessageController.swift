//
//  NewMessageController.swift
//  ChatApp
//
//  Created by Hyung Jip Moon on 2017-03-22.
//  Copyright © 2017 leomoon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    func fetchUser() {
        // fetch all of users in users node
        // it should return email and name
        
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
//            print("user found")
//            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                
                //if you use this setter, your app will crash if your class properties don't exactly match up with the firebase dictionary keys
                user.setValuesForKeys(dictionary)
                
                //     use this if you want other way around
                //user.name = dictionary["name"]

                //print(user.name, user.email)
                self.users.append(user)
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
            }
            
        }, withCancel: nil)
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // let use a hack for now, we actually need to dequeue our cells for memory efficiency
        //        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UserCell
        
        // Get reference for user
        let user = users[indexPath.row]
        cell?.textLabel?.text = user.name
        cell?.detailTextLabel?.text = user.email
        
//        cell.imageView?.image = UIImage(named: "lion")
//        cell.imageView?.contentMode = .scaleAspectFill
        if let profileImageUrl = user.profileImageURL {
            
            cell?.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
//            let url = NSURL(string: profileImageUrl)
//            URLSession.shared.dataTask(with: url! as URL, completionHandler: {(data, response, error) in
//                
//                //download hit an error so lets return out
//                if error != nil {
//                    print(error!)
//                    return
//                }
//                
//                DispatchQueue.main.async {
//                    
//                    cell?.profileImageView.image = UIImage(data: data!)
//                    // do something
//                   // cell.imageView?.image = UIImage(data: data!)
//                }
//            }).resume()
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)

        
    }
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "lion")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        // Use iOS 9 constraint anchors
        // Need x, y, width, height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

