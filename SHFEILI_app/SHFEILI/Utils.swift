//
//  Utils.swift
//  SHFEILI
//
//  Created by Michael Hu on 7/29/18.
//  Copyright © 2018 Sijie Tan. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    static func displayMessage(title: String, userMessage:String, view: UIViewController, handler:((UIAlertAction) -> Void)?) {
        
        
        let myAlert = UIAlertController(title:title, message:userMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:handler);
        
        myAlert.addAction(okAction);
        
        view.present(myAlert, animated: true, completion: nil);
    }
}
