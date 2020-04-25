//
//  popoverViewController.swift
//  FlowChart-iOSProject
//
//  Created by Soujanya Geddam on 03/30/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit

class popoverViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    var delegate:newSymptom?
    var symptom:String?
    
    @IBOutlet weak var symptomTF: UITextField!
    
    @IBAction func onNewSymptom(_ sender: Any) {
        let newsymptom1 = symptomTF.text
        if (newsymptom1 != nil) {
            delegate?.addSymptom(newsymptom: newsymptom1!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onMoodSwing(_ sender: Any) {
        delegate?.addSymptom(newsymptom: "mood swings")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCramping(_ sender: Any) {
        delegate?.addSymptom(newsymptom: "cramping")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onBackPain(_ sender: Any) {
        delegate?.addSymptom(newsymptom: "lower back pain")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onLowEnergy(_ sender: Any) {
        delegate?.addSymptom(newsymptom: "low energy")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(popoverViewController.tapRecognized))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    // make textfield visible when keyboard is there
    @IBAction func textFieldEditingDidBegin(_ sender: Any) {
        if symptomTF.text == "Enter a new symptom" {
            symptomTF.text = ""
        }
        self.scrollView.setContentOffset(CGPoint.init(x: 0, y: symptomTF.frame.maxY - self.view.frame.height * 0.55 ), animated: true)
    }
    
    // code to dismiss keyboard when user clicks on background

    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func tapRecognized() {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        view.endEditing(true)
        if symptomTF.text == "" {
            symptomTF.text = "Enter a new symptom"
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
