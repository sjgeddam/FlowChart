//
//  popoverViewController.swift
//  FlowChart-iOSProject
//
//  Created by Soujanya Geddam on 03/30/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit

class popoverViewController: UIViewController {
    
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
        
        // Do any additional setup after loading the view.
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
