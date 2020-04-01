//
//  TrackerViewController.swift
//  FlowChart-iOSProject
//
//  Created by Soujanya Geddam on 4/1/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit

protocol newSymptom {
    func addSymptom(symptom:String)
}

class TrackerViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource, newSymptom {

     var symptoms: [String] = []
     let cellReuseIdentifier = "cell"
     let cellSpacingHeight: CGFloat = 5
     var customTableViewCellIdentifier = "symptomCell"
     var popoverSegueIdentifier = "popoverSegue"
     var popoverVCIdentifier = "popoverVC"
     
     //sections are used to add spacing between cells
     func numberOfSections(in tableView: UITableView) -> Int {
         return self.symptoms.count
     }
     
     //only one row per section
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
     }
     
     //setting the spacing between cells
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return cellSpacingHeight
     }
     
     //make the background color show through
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let headerView = UIView()
         headerView.backgroundColor = UIColor.clear
         return headerView
     }
     
     //create a cell for each table view row
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: customTableViewCellIdentifier, for: indexPath) as! CustomTableViewCell
         // note that indexPath.section is used rather than indexPath.row
         cell.symptom.text = self.symptoms[indexPath.section]

         // add border and color
         cell.backgroundColor = UIColor.orange
         cell.layer.borderColor = UIColor.black.cgColor
         cell.layer.borderWidth = 1
         cell.layer.cornerRadius = 8
         cell.clipsToBounds = true
         return cell
     }
     
     //segueing into popoverVC after + button is clicked
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if (segue.identifier == popoverSegueIdentifier) {
             let destination = segue.destination as? popoverViewController
             destination?.delegate = self
         }
     }

     @IBOutlet weak var date: UILabel!
     @IBOutlet weak var symptomsTable: UITableView!
     
     override func viewDidLoad() {
         super.viewDidLoad()
         // Do any additional setup after loading the view.
         symptomsTable.delegate = self
         symptomsTable.dataSource = self
     }
     
     func addSymptom(symptom:String) {
         symptoms.append(symptom)
         symptomsTable.reloadData()
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
