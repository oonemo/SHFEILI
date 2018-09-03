//
//  LoginViewController.swift
//  SHFEILI
//
//  Created by Michael Hu on 7/22/18.
//  Copyright © 2018 Sijie Tan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    

    @IBOutlet weak var inputUsernameTextField: UITextField!
    @IBOutlet weak var inputPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        inputPasswordTextField.delegate = self
        inputUsernameTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func userLogin(_ sender: Any) {
        let inputUsername = inputUsernameTextField.text;
        let inputPassword = inputPasswordTextField.text;
        
        let endpoint = "/api/login/"
        
//        var data = NSMutableDictionary()
//        data["username"] = "shfeili"
//        data["password"] = "password"
        
        NetworkUtils.post(endpoint: endpoint, inputData:["username": inputUsername, "password": inputPassword]) {
            
        (result) in
            let succeed = result!["is_user"] as! Bool
            if (!succeed) {
                Utils.displayMessage(title: "Error", userMessage: "Login Failed.", view: self,  handler: nil)
            } else {
                Utils.displayMessage(title:"Succeed", userMessage: "Login succeeded!", view: self) {
                    action in self.dismiss(animated: true, completion: nil);
                }
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn");
                NetworkUtils.storeCookies()
                UserDefaults.standard.synchronize();
            }
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
