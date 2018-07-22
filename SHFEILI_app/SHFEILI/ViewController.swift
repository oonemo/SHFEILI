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
    
    var working = false
    
    @IBOutlet weak var progressBar: UICircularProgressRing!

    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.maxValue = 100
        progressBar.innerRingColor = UIColor.blue
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn");
        if (!isUserLoggedIn && !working) {
            performSegue(withIdentifier: "showLogin", sender: self)
        } else {
            progressBar.startProgress(to: 100, duration: 20.0)
            working = true
        }
    }
    
    @IBAction func stopProgress(_ sender: Any) {
        if (working) {
            progressBar.pauseProgress()
            working = false
        }
        else {
            progressBar.continueProgress()
            working = true
        }
        
    }
    
}

