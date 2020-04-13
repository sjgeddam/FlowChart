//
//  UserViewController.swift
//  FlowChart-iOSProject
//
//  Created by Abby Krishnan on 4/11/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserViewController: UIViewController {

    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    @IBOutlet weak var signupEmail: UITextField!
    @IBOutlet weak var signupPassword: UITextField!
    @IBOutlet weak var signupConfirm: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() {
          auth, user in
            if user != nil {
//                let vc = MainViewController()
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func loginAction(_ sender: Any) {
        guard let email = loginEmail.text,
              let password = loginPassword.text
        else {
          return
        }
        Auth.auth().signIn(withEmail: email, password: password) {
          user, error in
            if let _ = error, user == nil {
                
                let ac = UIAlertController(title: "Login Invalid", message: "Please use a valid login or make a new account", preferredStyle: .alert)
                let submitAction = UIAlertAction(title: "OK!", style: .default) { _ in
        
                }
                ac.addAction(submitAction)
                self.present(ac, animated: true)
            }
            else {
                 self.performSegue(withIdentifier: "LoginSegue", sender: self)
                
            }
        }
    }

    @IBAction func signupAction(_ sender: Any) {
        guard let emailField = signupEmail.text,
            let passwordField = signupPassword.text,
            let confirmedPasswordField = signupConfirm.text
        else {
            return
        }
        if passwordField != confirmedPasswordField {
            let ac = UIAlertController(title: "Signup Invalid", message: "Passwords don't match", preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "OK!", style: .default) { _ in
    
            }
            ac.addAction(submitAction)
            self.present(ac, animated: true)
        }
        else {
            Auth.auth().createUser(withEmail: emailField, password: passwordField) { user, error in
                if error == nil {
                    Auth.auth().signIn(withEmail: emailField, password: passwordField)
                    self.performSegue(withIdentifier: "SignupSegue", sender: self)

                }
                else {
                    let ac = UIAlertController(title: "Login Invalid", message: "Please use a valid login or make a new account", preferredStyle: .alert)
                    let submitAction = UIAlertAction(title: "OK!", style: .default) { _ in
            
                    }
                    ac.addAction(submitAction)
                    self.present(ac, animated: true)
                }
            }
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
