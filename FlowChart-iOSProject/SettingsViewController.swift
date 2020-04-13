//
//  SettingsViewController.swift
//  FlowChart-iOSProject
//
//  Created by Abby Krishnan on 4/13/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit
import FirebaseAuth


class SettingsViewController: UIViewController {

    @IBOutlet weak var notificationDays: UISlider!
    @IBOutlet weak var notifLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        notificationDays.isContinuous = false
        
        notifLabel.text = "notify me \(notificationDays.value) days before my predicted cycle"
    }
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sender.setValue(Float(roundf(sender.value)), animated: false)
        notifLabel.text = "notify me \(sender.value) days before my predicted cycle"
    }
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          self.performSegue(withIdentifier: "SettingsLogin", sender: self)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func newAccount(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          self.performSegue(withIdentifier: "SettingsSignup", sender: self)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

