//
//  MachineDetailViewController.swift
//  SHFEILI
//
//  Created by Michael Hu on 7/25/18.
//  Copyright © 2018 Sijie Tan. All rights reserved.
//

import UIKit

class MachineDetailViewController: UIViewController {
    
    var dataDict =  NSDictionary()
    
    var modelText: String = ""
    var totalTestedText: String = ""
    var errorCountText: String = ""
    var statusText: String = ""
    
    @IBOutlet weak var model: UITextField!
    @IBOutlet weak var totalTested: UITextField!
    @IBOutlet weak var errorCount: UITextField!
    @IBOutlet weak var status: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.text = modelText
        totalTested.text = totalTestedText
        errorCount.text = errorCountText
        status.text = statusText
        if (status.text == "Error") {
            status.textColor = UIColor.red
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
