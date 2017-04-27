//
//  LoginController+Handler.swift
//  ChatApp
//
//  Created by Hyung Jip Moon on 2017-04-27.
//  Copyright © 2017 leomoon. All rights reserved.
//

import UIKit
import Firebase

extension LoginController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            // guard statement would give me access to uid
            guard let uid = user?.uid else {
                return
            }
            
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("\(imageName).png")
            //let storageRef = FIRStorage.storage().reference().child("myImage.png")
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                    // if error occurs while uploading to firebase storage, print error message
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["name": name, "email": email, "profileImageURL": profileImageURL]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                    }
                    
                    //print(metadata!)
                })
            }
            
        })
        
    }

    func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        
        // successfully authenticated user
        let ref = FIRDatabase.database().reference(fromURL: "https://chatapp-44ec2.firebaseio.com/")
        //let usersReference = ref.child("users")
        let usersReference = ref.child("users").child(uid)
        
        //let values = ["name": name, "email": email, "profileImageURL": metadata.downloadURL()]
        
        //ref.updateChildValues(values, withCompletionBlock: {
        usersReference.updateChildValues(values, withCompletionBlock: {
            (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            
            print("saved user successfully into firebase db")
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    func handleSelectProfileImageView() {
        
        // To bring up the Image Picker, just create a reference to Picker Controller
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            //print((editedImage as AnyObject).size)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
            //print((originalImage as AnyObject).size)
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
            
        }
        dismiss(animated: true, completion: nil)
        //print(info)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled picker")
        dismiss(animated: true, completion: nil)
        
    }
}
