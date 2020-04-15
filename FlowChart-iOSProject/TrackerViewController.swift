//
//  TrackerViewController.swift
//  FlowChart-iOSProject
//
//  Created by Soujanya Geddam on 4/1/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth

protocol todaysDate {
    func sendDate() -> String
}

protocol newSymptom {
    func addSymptom(newsymptom:String)
}

class TrackerViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource, newSymptom, todaysDate {

    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 5
    var customTableViewCellIdentifier = "symptomCell"
    var popoverSegueIdentifier = "popoverSegue"
    var popoverVCIdentifier = "popoverVC"
     
    
    //only one row per section
    func tableView(_ tableView: UITableView,    numberOfRowsInSection section: Int) -> Int {
        return retrieveSymptoms().count
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
        print("in cell for row at func")
         let cell = tableView.dequeueReusableCell(withIdentifier: customTableViewCellIdentifier, for: indexPath) as! CustomTableViewCell
         // note that indexPath.section is used rather than indexPath.row
        let fetchedData = retrieveSymptoms()
        let symptomdescription = fetchedData[indexPath.row].value(forKey: "symptomtype") as? String
        cell.symptom.text = "  " + (symptomdescription ?? "")
        cell.symptom.clipsToBounds = true
        cell.symptom.layer.cornerRadius = 17
         
         return cell
     }
    
    
    func addSymptom(newsymptom:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let symptom = NSEntityDescription.insertNewObject(forEntityName: "Symptom", into: context)
        
        let user = Auth.auth().currentUser
    
        if ((user) != nil) {
            symptom.setValue(newsymptom, forKey: "symptomtype")
            symptom.setValue(date.text!, forKey: "date")
            symptom.setValue(user?.uid, forKey: "userID")
            
            // Commit the changes
            do {
                try context.save()
                print(newsymptom + " added")
            } catch {
                // If an error occurs
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            symptomsTable.reloadData()
        }
    }
    
    func clearCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Symptom")
        var fetchedResults:[NSManagedObject]
        
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            if fetchedResults.count > 0 {
                for result:AnyObject in fetchedResults {
                    context.delete(result as! NSManagedObject)
                }
            }
            try context.save()
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    func retrieveSymptoms() -> [NSManagedObject] {
        print("in retrieveing data!!!!")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Symptom")
        var fetchedResults:[NSManagedObject]? = nil

        let user = Auth.auth().currentUser
        if ((user) != nil) {
            //need to filter by both USERID and DATE
            let predicate = NSPredicate(format: "userID == %@", user!.uid)
            let secondpredicate = NSPredicate(format: "date == %@", date.text!)
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, secondpredicate])
            do {
                try fetchedResults = context.fetch(request) as? [NSManagedObject]
            } catch {
                // If an error occurs
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            print("before returning fetched results")
            return(fetchedResults)!
        } else {
            print("no results")
            return []
        }
    }
    
     
     //segueing into popoverVC after + button is clicked
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if (segue.identifier == popoverSegueIdentifier) {
             let destination = segue.destination as? popoverViewController
             destination?.delegate = self
         }
        
        if (segue.identifier == "moodSegue") {
            let destination = segue.destination as? MoodViewController
            destination?.delegate = self 
        }
        
        if (segue.identifier == "flowSegue") {
            let destination = segue.destination as? FlowViewController
            destination?.delegate = self
        }
     }

    var monthList = ["none", "january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"]
    @IBOutlet weak var symptomsTable: UITableView!
    @IBOutlet weak var date: UILabel!
    
    var delegate: UIViewController!
    var day = 1
    var month = 1
    var year = 2020
    var prevColor: UIColor!
    var markedDate: UIImageView!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        symptomsTable.delegate = self
        symptomsTable.dataSource = self
        symptomsTable.separatorStyle = .none
        symptomsTable.reloadData()
//        clearCoreData()
        self.navigationController!.setNavigationBarHidden(true,animated:false)
        if delegate is MainViewController {
            day = Calendar.current.component(.day, from: NSDate() as Date)
            month = Calendar.current.component(.month, from: NSDate() as Date)
            year = Calendar.current.component(.year, from: NSDate() as Date)
        }
        date.text = "\(monthList[month]) \(day), \(year)"
        
     }
     
    @IBAction func onBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        if delegate is CalendarViewController {
        } else {
            self.navigationController!.setNavigationBarHidden(false, animated: false)
        }
    }
    
    

    override func viewWillDisappear(_ animated: Bool) {
        if delegate is CalendarViewController {
            markedDate.tintColor = prevColor
        }
    }
    
    func sendDate() -> String {
        return date.text!
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
