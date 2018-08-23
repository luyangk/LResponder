//
//  QueenViewController.swift
//  LResponder
//
//  Created by Lucca Lu on 2018/8/22.
//  Copyright © 2018 Lucca Lu. All rights reserved.
//

import UIKit

class QueenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BonjourServerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var prepareBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    
    var bonjourServer: BonjourServer!
    var startTime: TimeInterval!
    var preparedFlag: Bool!
    var startedFlag: Bool!
    var dataList: [String:String]!
    
    func connected() {
    }
    
    func disconnected() {
    }
    
    func clearTimeAndSeq() {
        var count = 1
        for (deviceName, tmpStr) in self.dataList {
            self.dataList[deviceName] = "0:" + String(count)
            count += 1
        }
        self.tableView.reloadData()
    }
    
    func sortDataList() {
        for (deviceName, tmpStr) in self.dataList {
            let tmpStrArr = tmpStr.split(separator: ":")
            if String(tmpStrArr[0]) == "0" {
                self.dataList[deviceName] = "0:" + String(self.dataList.count)
            } else {
                var count = 1
                for (d, s) in self.dataList {
                    if deviceName != d {
                        if Double(tmpStrArr[0])! > Double(s.split(separator: ":")[0])! {
                            count += 1
                        }
                    }
                }
                self.dataList[deviceName] = String(tmpStrArr[0]) + ":" + String(count)
            }
        }
    }
    
    func handleBody(_ body: NSString?) {
        if preparedFlag == true && startedFlag == true {
            let tmpTime = Date().timeIntervalSince1970
            let timeUsed = String(format: "%.02f", tmpTime - self.startTime)
            let tmpName = body as String?
            // change used time value
            for (deviceName, tmpStr) in self.dataList {
                let tmpStrArr = tmpStr.split(separator: ":")
                if tmpName == deviceName && String(tmpStrArr[0]) == "0" {
                    if let index = tmpStr.range(of: ":")?.upperBound {
                        self.dataList[deviceName] = timeUsed + ":" + String(tmpStr[index...])
                    }
                }
            }
            self.sortDataList()
            self.tableView.reloadData()
        }
    }
    
    func didChangeServices() {
        var count = 1
        self.dataList.removeAll()
        for device in self.bonjourServer.devices {
            self.dataList[device.name] = "0:\(count)"
            count += 1
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.bonjourServer = BonjourServer()
        self.bonjourServer.delegate = self
        
        self.preparedFlag = false
        self.startedFlag = false
        
        self.dataList = ["":""]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.bonjourServer.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! QueenTableViewCell
        // Configure the cell...
        let row = indexPath.row
        let tmpDeviceName = self.bonjourServer.devices[row].name
        cell.teamNameLabel.text = tmpDeviceName
        let tmpStrArr = self.dataList[tmpDeviceName]?.split(separator: ":")
        let tmpTimeUsed = String(tmpStrArr![0])
        let tmpSeq = String(tmpStrArr![1])
        cell.usedTimeLabel.text = "\(tmpTimeUsed)\'\'"
        cell.seqLabel.text = "\(tmpSeq)"
        if tmpSeq == "1" && tmpTimeUsed != "0" {
            cell.seqLabel.textColor = UIColor.red
        } else {
            cell.seqLabel.textColor = UIColor.white
        }
        
        return cell
    }
    
    @IBAction func prepareBtnTouched(_ sender: Any) {
        if self.preparedFlag == false && self.startedFlag == false {
            print("prepare")
            for device in self.bonjourServer.devices {
                self.bonjourServer.connectTo(device)
            }
            self.preparedFlag = true
            self.startedFlag = false
            self.prepareBtn.setTitle("Prepared", for: .normal)
        }
    }
    @IBAction func startBtnTouched(_ sender: Any) {
        if self.preparedFlag == true && self.startedFlag == false {
            print("start")
            self.startedFlag = true
            self.startTime = Date().timeIntervalSince1970
            self.startBtn.setTitle("Stop", for: .normal)
        } else if self.preparedFlag == true && self.startedFlag == true {
            print("stop")
            self.startedFlag = false
            self.startBtn.setTitle("Start", for: .normal)
            self.clearTimeAndSeq()
        }
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
