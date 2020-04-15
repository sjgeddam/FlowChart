//
//  MoodViewController.swift
//  FlowChart-iOSProject
//
//  Created by Soujanya Geddam on 03/30/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth

class MoodViewController: UIViewController {
    
    var delegate:todaysDate?
    var currdate: String = ""
    
    @IBOutlet weak var smileButton: UIButton!
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var upsetButton: UIButton!
    
    var smileSelected = false
    var happySelected = false
    var neutralSelected = false
    var sadSelected = false
    var upsetSelected = false
    
    
    @IBAction func onSmile(_ sender: Any) {
        handlePrevious()
        
        let smile = UIImage(named: "reallyhappyfill")
        smileButton.setImage(smile, for: .normal)
        smileSelected = true
    }
    
    @IBAction func onHappy(_ sender: Any) {
        handlePrevious()
        
        let happy = UIImage(named: "happyfill")
        happyButton.setImage(happy, for: .normal)
        happySelected = true
    }
    
    @IBAction func onNeutral(_ sender: Any) {
        handlePrevious()
        
        let neutral = UIImage(named: "neutralfill")
        neutralButton.setImage(neutral, for: .normal)
        neutralSelected = true
    }
    
    @IBAction func onSad(_ sender: Any) {
        handlePrevious()
        
        let sad = UIImage(named: "sadfill")
        sadButton.setImage(sad, for: .normal)
        sadSelected = true
    }
    
    @IBAction func onUpset(_ sender: Any) {
        handlePrevious()
        
        let upset = UIImage(named: "upsetfill")
        upsetButton.setImage(upset, for: .normal)
        upsetSelected = true
    }
    
    
    @IBOutlet weak var reason: UITextField!
    
    @IBAction func onXmark(_ sender: Any) {
        //dismiss immediately: not saving any data
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCheckmark(_ sender: Any) {
        //need to save data first and then dismiss
        if (smileSelected) {
            storeMood(moodType: "smile")
        }
        if (happySelected) {
            storeMood(moodType: "happy")
        }
        if (neutralSelected) {
            storeMood(moodType: "neutral")
        }
        if (sadSelected) {
            storeMood(moodType: "sad")
        }
        if (upsetSelected) {
            storeMood(moodType: "upset")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //retrieve the data
        currdate = (delegate?.sendDate())!
        let fetchedResults = retrieveMood()

        for mood in fetchedResults {
            let description = mood.value(forKey: "reason")
            reason.text = description as? String
            if let feeling = mood.value(forKey:"moodtype") {
                if (feeling as? String == "smile") {
                    let smile = UIImage(named: "reallyhappyfill")
                    smileButton.setImage(smile, for: .normal)
                    smileSelected = true
                }
                if (feeling as? String == "happy") {
                    let happy = UIImage(named: "happyfill")
                    happyButton.setImage(happy, for: .normal)
                    happySelected = true
                }
                if (feeling as? String == "neutral") {
                    let neutral = UIImage(named: "neutralfill")
                    neutralButton.setImage(neutral, for: .normal)
                    neutralSelected = true
                }
                if (feeling as? String == "sad") {
                    let sad = UIImage(named: "sadfill")
                    sadButton.setImage(sad, for: .normal)
                    sadSelected = true
                }
                if (feeling as? String == "upset") {
                    let upset = UIImage(named: "upsetfill")
                    upsetButton.setImage(upset, for: .normal)
                    upsetSelected = true
                }
            }
        }
    }
    
    func deleteMood() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchedResults = retrieveMood()
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
    
    //clear core data for mood
    func clearCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mood")
        var fetchedResults:[NSManagedObject]
        
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            if fetchedResults.count > 0 {
                for result:AnyObject in fetchedResults {
                    context.delete(result as! NSManagedObject)
                    print("\(result.value(forKey: "moodtype")!) has been Deleted")
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
    
    func storeMood(moodType: String) {
        print("i get inside store mood")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let flow = NSEntityDescription.insertNewObject(forEntityName: "Mood", into: context)
        
        let user = Auth.auth().currentUser
        
        if ((user) != nil) {
            flow.setValue(user?.uid, forKey: "userID")
            flow.setValue(currdate, forKey: "date")
            flow.setValue(moodType, forKey: "moodtype")
            flow.setValue(reason.text, forKey: "reason")
            
            // Commit the changes
            do {
                try context.save()
                print("commited mood")
            } catch {
                // If an error occurs
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func retrieveMood() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mood")
        var fetchedResults:[NSManagedObject]? = nil

        let user = Auth.auth().currentUser
        if ((user) != nil) {
            //need to filter by both USERID and DATE
            let predicate = NSPredicate(format: "userID == %@", user!.uid)
            let secondpredicate = NSPredicate(format: "date == %@", currdate)
            //print("RETRIEVED DATE: " + currdate)
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
    
    func handlePrevious() {
        if (smileSelected) {
            let smile = UIImage(named: "reallyhappyface")
            smileButton.setImage(smile, for: .normal)
            deleteMood()
            smileSelected = false
        }
        if (happySelected) {
            let happy = UIImage(named: "happyface")
            happyButton.setImage(happy, for: .normal)
            deleteMood()
            happySelected = false
        }
        if (neutralSelected) {
            let neutral = UIImage(named: "neutralface")
            neutralButton.setImage(neutral, for: .normal)
            deleteMood()
            neutralSelected = false
        }
        if (sadSelected) {
            let sad = UIImage(named: "sadface")
            sadButton.setImage(sad, for: .normal)
            deleteMood()
            sadSelected = false
        }
        if (upsetSelected) {
            let upset = UIImage(named: "upsetface")
            upsetButton.setImage(upset, for: .normal)
            deleteMood()
            upsetSelected = false
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
