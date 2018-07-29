//
//  RegisterViewController.swift
//  SHFEILI
//
//  Created by Michael Hu on 7/29/18.
//  Copyright © 2018 Sijie Tan. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    
    @IBOutlet weak var oldUsername: UITextField!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newUsername: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var power: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createUser(_ sender: Any) {
        let oldUsernameText = oldUsername.text
        let oldPasswordText = oldPassword.text
        let newUsernameText = newUsername.text
        let newPasswordText = newPassword.text
        let confirmPasswordText = confirmPassword.text
        let powerUser = power.isOn
        
        if (confirmPasswordText != newPasswordText) {
            Utils.displayMessage(title: "Error!", userMessage: "Repeat password does not match!", view: self, handler: nil)
            return;
        }
        
        NetworkUtils.post(endpoint: "/api/create_user/", inputData: ["username": oldUsernameText, "password": oldPasswordText, "new_username": newUsernameText, "new_password": newPasswordText, "power": powerUser]) {
            (dictionary) in
            let succeed = dictionary?["succeeded"] as! Bool
            let reason = dictionary?["reason"] as! String
            
            print(succeed)
            print(reason)
            
            if (succeed) {
                Utils.displayMessage(title: "Succeed", userMessage: reason, view: self) {
                    action in self.dismiss(animated: true, completion: nil)
                }
            } else {
                Utils.displayMessage(title: "Failed", userMessage: reason, view: self, handler: nil)
            }
            
        }
    }
    
    @IBAction func cancelCreation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
