//
//  ReportViewController.swift
//  SHFEILI
//
//  Created by Michael Hu on 7/17/18.
//  Copyright © 2018 Sijie Tan. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableview: UITableView!
    var list = [String] ()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = list[indexPath.row] as! String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var str = list[indexPath.row].replacingOccurrences(of: "report ", with: "")
        str = "/api/reports/" + str + "/"
        let endPoint = str.replacingOccurrences(of: " ", with: "%20")
        NetworkUtils.get(endpoint: endPoint) {
            (dictionary) in
            if (dictionary == nil) {
                print("Receive empty dictionary")
                return;
            }
            print(dictionary)
//            let str = dictionary!["machineStatus"] as! String
//            let tempdict = NetworkUtils.jsonDecodeString(string: str, flag: false)
//            print(tempdict)
            if let machineStatus = dictionary!["machineStatus"] as? NSDictionary {
                print(machineStatus)
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "reportDetail") as! ReportDetailViewController
                viewController.totalTested = dictionary?["totalTested"] as! String
                viewController.totalScheduled = dictionary?["totalScheduled"] as! String
                viewController.timeStamp = endPoint
                viewController.machineDetailDict = machineStatus
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkUtils.get(endpoint: "/api/reports/") {
            (dictionary) in
            if (dictionary == nil) {
                print("Receive empty dictionary")
            }
            
            if let reportlist = dictionary!["reportsList"] as? [String] {
                print(reportlist)
                self.list = reportlist
            }
            self.tableview.reloadData()
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
