//
//  LoginViewController.swift
//  SHFEILI
//
//  Created by Michael Hu on 7/22/18.
//  Copyright © 2018 Sijie Tan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    let username = "shfeili"
    let password = "password"

    @IBOutlet weak var inputUsernameTextField: UITextField!
    @IBOutlet weak var inputPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad();

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
                self.displayMessage(title: "Error", userMessage: "Login Failed.", view: self,  handler: nil)
            } else {
                self.displayMessage(title:"Succeed", userMessage: "Login succeeded!", view: self) {
                    action in self.dismiss(animated: true, completion: nil);
                }
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn");
                UserDefaults.standard.synchronize();
            }
        }

    }
    
    func displayMessage(title: String, userMessage:String, view: UIViewController, handler:((UIAlertAction) -> Void)?) {

        
        let myAlert = UIAlertController(title:title, message:userMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:handler);

        myAlert.addAction(okAction);

        view.present(myAlert, animated: true, completion: nil);
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
