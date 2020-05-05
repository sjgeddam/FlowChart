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
        handleLight()
        
        let lightfill = UIImage(named: "lightfill")
        let lightnormal = UIImage(named: "light")
        
        let data1: NSData = lightfill!.pngData()! as NSData
        let data2: NSData = lightnormal!.pngData()! as NSData
        let lightdata: NSData = lightButton.currentImage!.pngData()! as NSData
         
        if (lightdata.isEqual(data1)) {
             let light = UIImage(named: "light")
             lightButton.setImage(light, for: .normal)
             lightSelected = false
        }
         
        if (lightdata.isEqual(data2)) {
             let light = UIImage(named: "lightfill")
             lightButton.setImage(light, for: .normal)
             lightSelected = true
        }
        
    }
    
    @IBAction func onMedium(_ sender: Any) {
        handleMedium()
        
        let mediumfill = UIImage(named: "mediumfill")
        let mediumnormal = UIImage(named: "medium")
        
        let data1: NSData = mediumfill!.pngData()! as NSData
        let data2: NSData = mediumnormal!.pngData()! as NSData
        let mediumdata: NSData = mediumButton.currentImage!.pngData()! as NSData
         
        if (mediumdata.isEqual(data1)) {
             let medium = UIImage(named: "medium")
             mediumButton.setImage(medium, for: .normal)
             mediumSelected = false
        }
         
        if (mediumdata.isEqual(data2)) {
             let medium = UIImage(named: "mediumfill")
             mediumButton.setImage(medium, for: .normal)
             mediumSelected = true
        }
    }
    
    @IBAction func onHeavy(_ sender: Any) {
        handleHeavy()
        
        let heavyfill = UIImage(named: "heavyfill")
        let heavynormal = UIImage(named: "heavy")
        
        let data1: NSData = heavyfill!.pngData()! as NSData
        let data2: NSData = heavynormal!.pngData()! as NSData
        let heavydata: NSData = heavyButton.currentImage!.pngData()! as NSData
         
        if (heavydata.isEqual(data1)) {
             let heavy = UIImage(named: "heavy")
             heavyButton.setImage(heavy, for: .normal)
             heavySelected = false
        }
         
        if (heavydata.isEqual(data2)) {
             let heavy = UIImage(named: "heavyfill")
             heavyButton.setImage(heavy, for: .normal)
             heavySelected = true
        }
    }
    
    @IBAction func onSpotting(_ sender: Any) {
        handleSpotting()
        
        let spottingfill = UIImage(named: "spottingfill")
        let spottingnormal = UIImage(named: "spottingupdate")
        
        let data1: NSData = spottingfill!.pngData()! as NSData
        let data2: NSData = spottingnormal!.pngData()! as NSData
        let spottingdata: NSData = spottingButton.currentImage!.pngData()! as NSData
         
        if (spottingdata.isEqual(data1)) {
             let spotting = UIImage(named: "spottingupdate")
             spottingButton.setImage(spotting, for: .normal)
             spottingSelected = false
        }
         
        if (spottingdata.isEqual(data2)) {
             let spotting = UIImage(named: "spottingfill")
             spottingButton.setImage(spotting, for: .normal)
             spottingSelected = true
        }
    }
    
    @IBAction func onDiscard(_ sender: Any) {
        //dismiss immediately
        self.navigationController?.popViewController(animated: true)
    }
    
    func resetbools() {
        lightSelected = false
        mediumSelected = false
        heavySelected = false
        spottingSelected = false
    }
    
    @IBAction func onSave(_ sender: Any) {
        
        let light = UIImage(named: "lightfill")
        let medium = UIImage(named: "mediumfill")
        let heavy = UIImage(named: "heavyfill")
        let spotting = UIImage(named: "spottingfill")
        
        let lightfill: NSData = light!.pngData()! as NSData
        let mediumfill: NSData = medium!.pngData()! as NSData
        let heavyfill: NSData = heavy!.pngData()! as NSData
        let spottingfill: NSData = spotting!.pngData()! as NSData
        
        let lightdata: NSData = lightButton.currentImage!.pngData()! as NSData
        let mediumdata: NSData = mediumButton.currentImage!.pngData()! as NSData
        let heavydata: NSData = heavyButton.currentImage!.pngData()! as NSData
        let spottingdata: NSData = spottingButton.currentImage!.pngData()! as NSData
        
        
        //need to save data first and then dismiss
        if (lightdata.isEqual(lightfill)) {
            if (mediumSelected || heavySelected || spottingSelected) {
                deleteFlow()
                resetbools()
            }
            storeFlow(flowType: "light")
        }
        else if (mediumdata.isEqual(mediumfill)) {
            if (lightSelected || heavySelected || spottingSelected) {
                deleteFlow()
                resetbools()
            }
            storeFlow(flowType: "medium")
        }
        else if (heavydata.isEqual(heavyfill)) {
            if (lightSelected || mediumSelected || spottingSelected) {
                deleteFlow()
                resetbools()
            }
            storeFlow(flowType: "heavy")
        }
        else if (spottingdata.isEqual(spottingfill)) {
            if (lightSelected || mediumSelected || heavySelected) {
                deleteFlow()
                resetbools()
            }
            storeFlow(flowType: "spotting")
        }
        else {
            deleteFlow()
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
            addCycle(date: currdate)
            
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
    
    func addCycle(date: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd, yyyy"
        let d:Date = dateFormatter.date(from: date )!
        
        let cycle = PeriodData.retrieveItems(item: "Cycle").sorted(by: { ($0.value(forKey: "start") as! Date).compare($1.value(forKey: "start") as! Date) == .orderedDescending })
//        var lastEnd:Date? = nil
        
        var addedToDatabase = false
        for entry in cycle {
            let start:Date = entry.value(forKey: "start") as! Date
            let end:Date = entry.value(forKey: "end") as! Date
            
            
            // check if date added is before current start
            var dateDifference = Calendar.current.dateComponents([.day], from: d, to: start).day!
            if dateDifference == 1 {
                addedToDatabase = true
                fixCycle(oldStart: start, newStart: d, newEnd: end)
                mergeDates()
            }
            // check if date added is after current end
            dateDifference = Calendar.current.dateComponents([.day], from: end, to: d).day!
            if dateDifference == 1 {
                addedToDatabase = true
                fixCycle(oldStart: start, newStart: start, newEnd: d)
                mergeDates()
            }
        }
        if !addedToDatabase {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Cycle")
            var fetchedResults:[NSManagedObject]? = nil
            let user =  Auth.auth().currentUser
            
            if ((user) != nil) {
                let predicate = NSPredicate(format: "userID == %@", user!.uid)
                let secondpredicate = NSPredicate(format: "start == %@", d as NSDate)
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, secondpredicate])
                do {
                    try fetchedResults = context.fetch(request) as? [NSManagedObject]
                } catch {
                    // If an error occurs
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
                if fetchedResults!.count == 0 {
                    print("adding lone date. start & end \(d)")
                    storeCycle(start: d, end: d)
                }
                else {
                    print("date \(d) already exists")
                }
            }
        }
    }
    
    func fixCycle(oldStart:Date, newStart:Date, newEnd:Date) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Cycle")
        var fetchedResults:[NSManagedObject]? = nil
        let user =  Auth.auth().currentUser
        
        if ((user) != nil) {
            let predicate = NSPredicate(format: "userID == %@", user!.uid)
            let secondpredicate = NSPredicate(format: "start == %@", oldStart as NSDate)
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, secondpredicate])
            do {
                try fetchedResults = context.fetch(request) as? [NSManagedObject]
            } catch {
                // If an error occurs
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            
            // update old entry
            let entry = fetchedResults![0]
            entry.setValue(newStart, forKey: "start")
            entry.setValue(newEnd, forKey: "end")
            print("fixing cycle. old start \(oldStart), old end \(entry.value(forKey: "end")) - new start \(newStart), new end \(newEnd)")
//            for entry in fetchedResults! {
//                if entry.value(forKey: "start") as! Date == oldStart {
//                    entry.setValue(newStart, forKey: "start")
//                    entry.setValue(oldStart, forKey: "end")
//                    break
//                }
//            }
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
    
    func mergeDates() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Cycle")
        var fetchedResults:[NSManagedObject]? = nil
        let user =  Auth.auth().currentUser
       
        if ((user) != nil) {
           let predicate = NSPredicate(format: "userID == %@", user!.uid)
           request.predicate = predicate
           do {
               try fetchedResults = context.fetch(request) as? [NSManagedObject]
           } catch {
               // If an error occurs
               let nserror = error as NSError
               NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
               abort()
           }
           
            // see if any entries need to be merged
            fetchedResults = fetchedResults!.sorted(by: { ($0.value(forKey: "start") as! Date).compare($1.value(forKey: "start") as! Date) == .orderedAscending })
            var lastEndDate = Date()
            for (index, entry) in (fetchedResults?.enumerated())! {
                let start = entry.value(forKey: "start") as! Date
                let end = entry.value(forKey: "end") as! Date
                if index != 0 {
                    if lastEndDate == start {       // found a merge
                        print("merging date \(start)")
                        let oldEntry = fetchedResults![index-1]
                        oldEntry.setValue(end, forKey: "end")
                        context.delete(entry)
                        break
                    }
                }
                lastEndDate = end
            }
            
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
    
    func storeCycle(start:Date, end:Date) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let cycle = NSEntityDescription.insertNewObject(forEntityName: "Cycle", into: context)

        let user = Auth.auth().currentUser

        if ((user) != nil) {
            cycle.setValue(user?.uid, forKey: "userID")
            cycle.setValue(start, forKey: "start")
            cycle.setValue(end, forKey: "end")
            print("creating new cycle start \(start), end \(end)")

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
    
    func handleLight() {
        if (mediumSelected) {
            let medium = UIImage(named: "medium")
            mediumButton.setImage(medium, for: .normal)
        }
        if (heavySelected) {
            let heavy = UIImage(named: "heavy")
            heavyButton.setImage(heavy, for: .normal)
        }
        if (spottingSelected) {
            let spotting = UIImage(named: "spottingupdate")
            spottingButton.setImage(spotting, for: .normal)
        }
    }
    
    func handleMedium() {
        if (lightSelected) {
            let light = UIImage(named: "light")
            lightButton.setImage(light, for: .normal)
        }
        if (heavySelected) {
            let heavy = UIImage(named: "heavy")
            heavyButton.setImage(heavy, for: .normal)
        }
        if (spottingSelected) {
            let spotting = UIImage(named: "spottingupdate")
            spottingButton.setImage(spotting, for: .normal)
        }
    }
    
    func handleHeavy() {
        if (lightSelected) {
            let light = UIImage(named: "light")
            lightButton.setImage(light, for: .normal)
        }
        if (mediumSelected) {
            let medium = UIImage(named: "medium")
            mediumButton.setImage(medium, for: .normal)
        }
        if (spottingSelected) {
            let spotting = UIImage(named: "spottingupdate")
            spottingButton.setImage(spotting, for: .normal)
        }
    }
    
    func handleSpotting() {
        if (lightSelected) {
            let light = UIImage(named: "light")
            lightButton.setImage(light, for: .normal)
        }
        if (mediumSelected) {
            let medium = UIImage(named: "medium")
            mediumButton.setImage(medium, for: .normal)
        }
        if (heavySelected) {
            let heavy = UIImage(named: "heavy")
            heavyButton.setImage(heavy, for: .normal)
        }
    }
    
    
    func deleteFlow() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchedResults = retrieveFlow()
        if fetchedResults.count == 0 {
            return
        }
        let item = fetchedResults[0]
        let start = item.value(forKey: "date")
        
        context.delete(item)
        do {
            try context.save()
            deleteCycle(datestring: start as! String)
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
    }
    
    func deleteCycle(datestring: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd, yyyy"
        let date:Date = dateFormatter.date(from: datestring )!

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let cycle = PeriodData.retrieveItems(item: "Cycle")
        
        if cycle.count == 0 {
            return
        }
        
        var start = Date()
        var end = Date()
        for entry in cycle {
            start = entry.value(forKey: "start") as! Date
            end = entry.value(forKey: "end") as! Date
            if start > end {
                let temp = end
                end = start
                start = temp
            }
            if (start ... end).contains(date) {
                if start < date {
                    fixCycle(oldStart: start, newStart: start, newEnd: Calendar.current.date(byAdding: .day, value: -1, to: date)!)
                }
                if end > date {
                    storeCycle(start: Calendar.current.date(byAdding: .day, value: 1, to: date)!, end: end)
                }
                if start.compare(end) == .orderedSame {
                    print("deleting same date entry")
                    context.delete(entry)
                }
    
            }
//            if entry.value(forKey: "start") as! Date == date {
//                start = entry.value(forKey: "start") as! Date
//                end = entry.value(forKey: "end") as! Date
//                context.delete(entry)
//                break
//            }
        }
        
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
        //clearCoreData()
        // retrieve data
        currdate = (delegate?.sendDate())!
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
