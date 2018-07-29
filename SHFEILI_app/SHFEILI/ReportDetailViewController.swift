//
//  ReportDetailViewController.swift
//  SHFEILI
//
//  Created by Michael Hu on 7/29/18.
//  Copyright © 2018 Sijie Tan. All rights reserved.
//

import UIKit

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class ReportDetailViewController: UITableViewController {
    
    var machineDetailDict = NSDictionary()
    var totalScheduled = String()
    var totalTested = String()
    var timeStamp = String()
    
    var tableViewData = [cellData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let timeStr = timeStamp.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "apireports", with: "").replacingOccurrences(of: "%20", with: " ")
        let firstCell = cellData(opened: false, title: "SystemStatus", sectionData: ["Time: \(timeStr)", "Total scheduled: \(totalScheduled)", "Total tested: \(totalTested)"])
        tableViewData.append(firstCell)
        for index in 0...machineDetailDict.count - 1 {
            let str = machineDetailDict["\(index)"] as! String
            let dict = NetworkUtils.jsonDecodeString(string: str, flag: true)
            print(dict)
            let model = dict!["model"] as! String
            let numError = dict!["numError"] as! Int
            let status = dict!["status"] as! String
            let cell = cellData(opened: false, title: "Machine \(index)", sectionData: ["Model: \(model)", "Error: \(numError)", "Status: \(status)"])
            tableViewData.append(cell)
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tableViewData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (tableViewData[section].opened == true) {
            return tableViewData[section].sectionData.count + 1
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell") else {return UITableViewCell()}
            cell.textLabel?.text = tableViewData[indexPath.section].title
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell") else {return UITableViewCell()}
            cell.backgroundColor = UIColor.gray
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableViewData[indexPath.section].opened == true {
            tableViewData[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        
        } else {
            tableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
    }

}
