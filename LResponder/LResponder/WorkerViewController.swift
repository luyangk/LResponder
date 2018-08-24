//
//  WorkerViewController.swift
//  LResponder
//
//  Created by Lucca Lu on 2018/8/20.
//  Copyright © 2018 Lucca Lu. All rights reserved.
//

import UIKit
import AudioToolbox

class WorkerViewController: UIViewController, BonjourClientDelegate, UITextFieldDelegate {
    var bonjourClient: BonjourClient!
    
    @IBOutlet weak var respondBtn: UIButton!
    @IBOutlet weak var teamNameInput: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    var teamNameStr: String!
    
    func connectedTo(_ socket: GCDAsyncSocket!) {
    }
    
    func disconnected() {
    }
    
    func handleBody(_ body: NSString?) {
        let tmpResult = body as String?
        if tmpResult == "Started" {
            self.resultLabel.text = "Started"
            self.resultLabel.textColor = .green
            self.view.backgroundColor = UIColor(red: 39/255, green: 162/255, blue: 216/255, alpha: 1)
            navigationController?.navigationBar.barTintColor = UIColor(red: 39/255, green: 162/255, blue: 216/255, alpha: 1)
            return
        } else if tmpResult == "Not Started" {
            self.resultLabel.text = "请勿抢答"
            self.resultLabel.textColor = .white
            self.view.backgroundColor = UIColor(red: 244/255, green: 160/255, blue: 93/255, alpha: 1)
            navigationController?.navigationBar.barTintColor = UIColor(red: 244/255, green: 160/255, blue: 93/255, alpha: 1)
            return
        } else if tmpResult == "Stopped" {
            self.resultLabel.text = ""
            self.resultLabel.textColor = .white
            self.view.backgroundColor = UIColor(red: 39/255, green: 162/255, blue: 216/255, alpha: 1)
            navigationController?.navigationBar.barTintColor = UIColor(red: 39/255, green: 162/255, blue: 216/255, alpha: 1)
            return
        }
        self.resultLabel.text = tmpResult
        let tmpArr = tmpResult?.split(separator: ":")
        if String(tmpArr![1]) == self.teamNameInput.text {
            self.resultLabel.textColor = .white
            self.view.backgroundColor = UIColor(red: 56/255, green: 244/255, blue: 216/255, alpha: 1)
            navigationController?.navigationBar.barTintColor = UIColor(red: 56/255, green: 244/255, blue: 216/255, alpha: 1)
//            playNotifySound(soundStr: "success")
        } else {
            self.resultLabel.textColor = .white
            self.view.backgroundColor = UIColor(red: 247/255, green: 111/255, blue: 131/255, alpha: 1)
            navigationController?.navigationBar.barTintColor = UIColor(red: 247/255, green: 111/255, blue: 131/255, alpha: 1)
//            playNotifySound(soundStr: "fail")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.teamNameInput.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func respondBtnTouched(_ sender: Any) {
        if self.teamNameStr != nil && self.teamNameStr != "" {
            let data = self.teamNameStr.data(using: String.Encoding.utf8)
            self.bonjourClient.send(data!)
        }
    }
    
    func playNotifySound(soundStr: String) {
        var soundID: SystemSoundID = 0
        let path = Bundle.main.path(forResource: soundStr, ofType: "mp3")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundID)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // text field delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.teamNameInput.text == nil || self.teamNameInput.text == "" {
            let alert = UIAlertController(title: "Warning Message", message: "Please input team name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return textField.resignFirstResponder()
        }
        
        self.teamNameStr = self.teamNameInput.text
        
        if self.bonjourClient == nil {
            self.bonjourClient = BonjourClient()
            self.bonjourClient.delegate = self
        }
        
        self.bonjourClient.startBroadCasting(name: self.teamNameStr)
        
        return textField.resignFirstResponder()
    }

}
