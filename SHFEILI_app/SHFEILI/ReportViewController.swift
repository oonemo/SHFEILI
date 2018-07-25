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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkUtils.get(endpoint: "http://localhost:8000/api/reports/") {
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
