//
//  MonitorViewController.swift
//  SHFEILI
//
//  Created by Michael Hu on 7/17/18.
//  Copyright © 2018 Sijie Tan. All rights reserved.
//

import UIKit

class MonitorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var data = NSDictionary()
    var machineStatus = NSDictionary()
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let working = data["working"] as? Bool {
            if (working) {
                self.machineStatus = data["machineStatus"] as! NSDictionary
                return machineStatus.count
            } else {
                return 0;
            }
        } else{
            print("data emptty!")
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "machine")
        cell.textLabel?.text =  "machine \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str = machineStatus["\(indexPath.row)"] as! String
        let dictStr = str.replacingOccurrences(of: "'", with: "\"")
        let jsonData = dictStr.data(using: .utf8)
        let dict = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as! NSDictionary
        let viewController = storyboard?.instantiateViewController(withIdentifier: "machineDetail") as! MachineDetailViewController
        
        let errorCount = dict!["numError"] as! Int
        let totalTestedText = data["totalTested"] as! String
        let statusText = dict!["status"] as! String
        let modelText = dict!["model"] as! String
        
        print(errorCount)
        print(totalTestedText)
        
        viewController.errorCountText = "\(errorCount)"
        viewController.totalTestedText = "\(totalTestedText)"
        viewController.statusText = "\(statusText)"
        viewController.modelText = "\(modelText)"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkUtils.get(endpoint: "/api/system_status/") {
            (dictionary) in
            if (dictionary == nil) {
                print("Receive empty dictionary")
            }
            
            self.data = dictionary!
            self.tableView.reloadData()
            print(dictionary)
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
