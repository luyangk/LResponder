//
//  WorkerViewController.swift
//  LResponder
//
//  Created by Lucca Lu on 2018/8/20.
//  Copyright © 2018 Lucca Lu. All rights reserved.
//

import UIKit

class WorkerViewController: UIViewController, BonjourClientDelegate, UITextFieldDelegate {
    var bonjourClient: BonjourClient!
    
    @IBOutlet weak var respondBtn: UIButton!
    @IBOutlet weak var teamNameInput: UITextField!
    var teamNameStr: String!
    
    func connectedTo(_ socket: GCDAsyncSocket!) {
    }
    
    func disconnected() {
    }
    
    func handleBody(_ body: NSString?) {
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
