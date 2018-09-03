//
//  RegisterViewController.swift
//  SHFEILI
//
//  Created by Michael Hu on 7/29/18.
//  Copyright © 2018 Sijie Tan. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var oldUsername: UITextField!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newUsername: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var power: UISwitch!
    
    var viewHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oldUsername.delegate = self
        self.oldPassword.delegate = self
        self.newUsername.delegate = self
        self.newPassword.delegate = self
        self.confirmPassword.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.kbFrameChanged(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.kbFrameReturn(_:)),
            name: .UIKeyboardWillHide, object: nil)
        viewHeight = self.view.frame.origin.y
        // Do any additional setup after loading the view.
    }
    
    @objc func kbFrameChanged(_ notification : Notification){
        let info = notification.userInfo
        let kbRect = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let offsetY = kbRect.origin.y - UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: offsetY)
        }
    }
    
    @objc func kbFrameReturn(_ textField: UITextField) -> Bool {
        self.view.resignFirstResponder()
        
        //让textView bottom位置还原
        UIView.animate(withDuration: 0.1, animations: {
            var frame = self.view.frame
            frame.origin.y = self.viewHeight
            self.view.frame = frame
        })
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
