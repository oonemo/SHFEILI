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
            
        if ((inputPassword!.isEmpty) || (inputUsername!.isEmpty)) {
            displayMessage(title:"Alert", userMessage: "All Fields Must be entered!", handler: nil);
            return;
        }
            
        if (inputUsername != "shfeili") {
            displayMessage(title:"Alert", userMessage: "User do not exist!", handler: nil);
            return;
        } else {
            if (inputPassword != "password") {
                displayMessage(title:"Alert", userMessage: "Wrong password!", handler: nil);
                return;
            }
        }
            
        displayMessage(title:"Succeed", userMessage: "Login succeeded!") {
            action in self.dismiss(animated: true, completion: nil);
        }
        
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn");
        UserDefaults.standard.synchronize();
        
    }
    
    func displayMessage(title: String, userMessage:String, handler:((UIAlertAction) -> Void)?) {

        let myAlert = UIAlertController(title:title, message:userMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:handler);

        myAlert.addAction(okAction);

        self.present(myAlert, animated: true, completion: nil);
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
