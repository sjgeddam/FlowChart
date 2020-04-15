//
//  FlowViewController.swift
//  FlowChart-iOSProject
//
//  Created by Soujanya Geddam on 03/30/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth

class FlowViewController: UIViewController {
    
    @IBOutlet weak var lightButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var heavyButton: UIButton!
    @IBOutlet weak var spottingButton: UIButton!
    
    var delegate:todaysDate?
    var currdate: String = ""
    
    var lightSelected = false
    var mediumSelected = false
    var heavySelected = false
    var spottingSelected = false
    
    @IBAction func onLight(_ sender: Any) {
        handlePrevious()
        
        let light = UIImage(named: "lightfill")
        lightButton.setImage(light, for: .normal)
        lightSelected = true
    }
    
    @IBAction func onMedium(_ sender: Any) {
        handlePrevious()
        
        let medium = UIImage(named: "mediumfill")
        mediumButton.setImage(medium, for: .normal)
        mediumSelected = true
    }
    
    @IBAction func onHeavy(_ sender: Any) {
        handlePrevious()
        
        let heavy = UIImage(named: "heavyfill")
        heavyButton.setImage(heavy, for: .normal)
        heavySelected = true
    }
    
    @IBAction func onSpotting(_ sender: Any) {
        handlePrevious()
        
        let spotting = UIImage(named: "spottingfill")
        spottingButton.setImage(spotting, for: .normal)
        spottingSelected = true
    }
    
    @IBAction func onDiscard(_ sender: Any) {
        //dismiss immediately
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSave(_ sender: Any) {
        //need to save data first and then dismiss
        if (lightSelected) {
            storeFlow(flowType: "light")
        } else if (mediumSelected) {
            storeFlow(flowType: "medium")
        } else if (heavySelected) {
            storeFlow(flowType: "heavy")
        } else if (spottingSelected) {
            storeFlow(flowType: "spotting")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func retrieveFlow() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Flow")
        var fetchedResults:[NSManagedObject]? = nil

        let user = Auth.auth().currentUser
        if ((user) != nil) {
            //need to filter by both USERID and DATE
            let predicate = NSPredicate(format: "userID == %@", user!.uid)
            let secondpredicate = NSPredicate(format: "date == %@", currdate)
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, secondpredicate])
            do {
                try fetchedResults = context.fetch(request) as? [NSManagedObject]
            } catch {
                // If an error occurs
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            return(fetchedResults)!
        } else {
            print("no results")
            return []
        }
    }
    
    //clear core data for flow
    func clearCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Flow")
        var fetchedResults:[NSManagedObject]
        
        print("hello")
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            if fetchedResults.count > 0 {
                for result:AnyObject in fetchedResults {
                    context.delete(result as! NSManagedObject)
                    print("\(result.value(forKey: "flowtype")!) has been Deleted")
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
    
    func storeFlow(flowType: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let flow = NSEntityDescription.insertNewObject(forEntityName: "Flow", into: context)
        
        let user = Auth.auth().currentUser
        
        if ((user) != nil) {
            flow.setValue(user?.uid, forKey: "userID")
            flow.setValue(currdate, forKey: "date")
            flow.setValue(flowType, forKey: "flowtype")
            
            // Commit the changes
            do {
                try context.save()
            } catch {
                // If an error occurs
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func handlePrevious() {
        if (lightSelected) {
            let light = UIImage(named: "light")
            lightButton.setImage(light, for: .normal)
            deleteFlow()
            lightSelected = false
        }
        if (mediumSelected) {
            let medium = UIImage(named: "medium")
            mediumButton.setImage(medium, for: .normal)
            deleteFlow()
            mediumSelected = false
        }
        if (heavySelected) {
            let heavy = UIImage(named: "heavy")
            heavyButton.setImage(heavy, for: .normal)
            deleteFlow()
            heavySelected = false
        }
        if (spottingSelected) {
            let spotting = UIImage(named: "spottingupdate")
            spottingButton.setImage(spotting, for: .normal)
            deleteFlow()
            spottingSelected = false
        }
    }
    
    func deleteFlow() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchedResults = retrieveFlow()
        let item = fetchedResults[0]
        
        context.delete(item)
        do {
            try context.save()
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // retrieve data
        currdate = (delegate?.sendDate())!
//        clearCoreData()
        let fetchedResults = retrieveFlow()
        
        for flow in fetchedResults {
            if let level = flow.value(forKey:"flowtype") {
                //need to fill buttons w respective flow levels
                if (level as? String == "light") {
                    let light = UIImage(named: "lightfill")
                    lightButton.setImage(light, for: .normal)
                    lightSelected = true
                }
                if (level as? String == "medium") {
                    let medium = UIImage(named: "mediumfill")
                    mediumButton.setImage(medium, for: .normal)
                    mediumSelected = true
                }
                if (level as? String == "heavy") {
                    let heavy = UIImage(named: "heavyfill")
                    heavyButton.setImage(heavy, for: .normal)
                    heavySelected = true
                }
                if (level as? String == "spotting") {
                    let spotting = UIImage(named: "spottingfill")
                    spottingButton.setImage(spotting, for: .normal)
                    spottingSelected = true
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
