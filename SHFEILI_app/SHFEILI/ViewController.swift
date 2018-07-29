//
//  ViewController.swift
//  SHFEILI
//
//  Created by Nemo on 7/11/18.
//  Copyright © 2018 Sijie Tan. All rights reserved.
//

import UIKit
import UICircularProgressRing


class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn");
        if (!isUserLoggedIn) {
            performSegue(withIdentifier: "showLogin", sender: self)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    @IBAction func stopProgress(_ sender: Any) {
        
    }
    
    @IBAction func logout(_ sender: Any) {
        NetworkUtils.deleteAllCookies()
        let domain = Bundle.main.bundleIdentifier!;
        UserDefaults.standard.removePersistentDomain(forName: domain);
        UserDefaults.standard.synchronize();
        performSegue(withIdentifier: "showLogin", sender: self)
    }
    
}

