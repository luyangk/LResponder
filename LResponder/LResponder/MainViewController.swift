//
//  MainViewController.swift
//  LResponder
//
//  Created by Lucca Lu on 2018/8/20.
//  Copyright © 2018 Lucca Lu. All rights reserved.
//

import UIKit
import Reachability

class MainViewController: UIViewController {
    var reachability: Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        stopNotifier()
        
        let reachability: Reachability?
        
        reachability = Reachability(hostname: "apple.com")
        
        self.reachability = reachability
        print("--- set up reachability")
        
        reachability?.whenReachable = { reachability in
            print("reachable")
        }
        reachability?.whenUnreachable = { reachability in
            print("not reachable")
            self.singleButtonAlert()
        }
        
        startNotifier()
//        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
//            let infoDict = NSDictionary(contentsOfFile: path) {
//              if infoDict.value(forKey: "FirstTimeOpen") as! Bool == true {
//              }
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func singleButtonAlert() {
        let alert = UIAlertController(title: "Notification", message: "Please check your network setting.", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            print("unable to start notifier")
            return
        }
    }
    
    func stopNotifier() {
        print("--- stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability = nil
    }
    
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.connection != .none {
            print("reachable")
        } else {
            print("not reachable")
            self.singleButtonAlert()
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
