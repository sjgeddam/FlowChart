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


class MoodViewController: UIViewController{

    
    
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
        handleSmile()
        
        let smilefill = UIImage(named: "reallyhappyfill")
        let smilenormal = UIImage(named: "reallyhappyface")
       
        let data1: NSData = smilefill!.pngData()! as NSData
        let data2: NSData = smilenormal!.pngData()! as NSData
        let smiledata: NSData = smileButton.currentImage!.pngData()! as NSData
        
        if (smiledata.isEqual(data1)) {
            let smile = UIImage(named: "reallyhappyface")
            smileButton.setImage(smile, for: .normal)
            smileSelected = false
        }
        
        if (smiledata.isEqual(data2)) {
            print("i get in smile normal")
            let smile = UIImage(named: "reallyhappyfill")
            smileButton.setImage(smile, for: .normal)
            smileSelected = true
        }
        
    }
    
    @IBAction func onHappy(_ sender: Any) {
        handleHappy()
        
        let happyfill = UIImage(named: "happyfill")
        let happynormal = UIImage(named: "happyface")
        
        let data1: NSData = happyfill!.pngData()! as NSData
        let data2: NSData = happynormal!.pngData()! as NSData
        let happydata: NSData = happyButton.currentImage!.pngData()! as NSData
        
        if (happydata.isEqual(data1)) {
            let happy = UIImage(named: "happyface")
            happyButton.setImage(happy, for: .normal)
            happySelected = false
        }
        
        if (happydata.isEqual(data2)) {
            let happy = UIImage(named: "happyfill")
            happyButton.setImage(happy, for: .normal)
            happySelected = true
        }
    
    }

    
    @IBAction func onNeutral(_ sender: Any) {
        handleNeutral()
        
        let neutralfill = UIImage(named: "neutralfill")
        let neutralnormal = UIImage(named: "neutralface")
        
        let data1: NSData = neutralfill!.pngData()! as NSData
        let data2: NSData = neutralnormal!.pngData()! as NSData
        let neutraldata: NSData = neutralButton.currentImage!.pngData()! as NSData
        
        if (neutraldata.isEqual(data1)) {
            let neutral = UIImage(named: "neutralface")
            neutralButton.setImage(neutral, for: .normal)
            neutralSelected = false
        }
        
        if (neutraldata.isEqual(data2)) {
            let neutral = UIImage(named: "neutralfill")
            neutralButton.setImage(neutral, for: .normal)
            neutralSelected = true
        }
    }
    
    @IBAction func onSad(_ sender: Any) {
        handleSad()
        
        let sadfill = UIImage(named: "sadfill")
        let sadnormal = UIImage(named: "sadface")
        
        let data1: NSData = sadfill!.pngData()! as NSData
        let data2: NSData = sadnormal!.pngData()! as NSData
        let saddata: NSData = sadButton.currentImage!.pngData()! as NSData
        
        if (saddata.isEqual(data1)) {
            let sad = UIImage(named: "sadface")
            sadButton.setImage(sad, for: .normal)
            sadSelected = false
        }
        
        if (saddata.isEqual(data2)) {
            let sad = UIImage(named: "sadfill")
            sadButton.setImage(sad, for: .normal)
            sadSelected = true
        }
    }
    
    @IBAction func onUpset(_ sender: Any) {
        handleUpset()
        
        let upsetfill = UIImage(named: "upsetfill")
        let upsetnormal = UIImage(named: "upsetface")
        
        let data1: NSData = upsetfill!.pngData()! as NSData
        let data2: NSData = upsetnormal!.pngData()! as NSData
        let upsetdata: NSData = upsetButton.currentImage!.pngData()! as NSData
        
        if (upsetdata.isEqual(data1)) {
            let upset = UIImage(named: "upsetface")
            upsetButton.setImage(upset, for: .normal)
            upsetSelected = false
        }
        
        if (upsetdata.isEqual(data2)) {
            let upset = UIImage(named: "upsetfill")
            upsetButton.setImage(upset, for: .normal)
            upsetSelected = true
        }
    }
    
    
    @IBOutlet weak var reason: UITextField!
    
    @IBAction func onXmark(_ sender: Any) {
        //dismiss immediately: not saving any data
        self.navigationController?.popViewController(animated: true)
    }
    
    func resetbools() {
        smileSelected = false
        happySelected = false
        neutralSelected = false
        sadSelected = false
        upsetSelected = false
    }
    
    @IBAction func onCheckmark(_ sender: Any) {
        //need to save data first and then dismiss
        
        let smile = UIImage(named: "reallyhappyfill")
        let happy = UIImage(named: "happyfill")
        let neutral = UIImage(named: "neutralfill")
        let sad = UIImage(named: "sadfill")
        let upset = UIImage(named: "upsetfill")
        
        let smilefill: NSData = smile!.pngData()! as NSData
        let happyfill: NSData = happy!.pngData()! as NSData
        let neutralfill: NSData = neutral!.pngData()! as NSData
        let sadfill: NSData = sad!.pngData()! as NSData
        let upsetfill: NSData = upset!.pngData()! as NSData
        
        let smiledata: NSData = smileButton.currentImage!.pngData()! as NSData
        let happydata: NSData = happyButton.currentImage!.pngData()! as NSData
        let neutraldata: NSData = neutralButton.currentImage!.pngData()! as NSData
        let saddata: NSData = sadButton.currentImage!.pngData()! as NSData
        let upsetdata: NSData = upsetButton.currentImage!.pngData()! as NSData
        
        if (smiledata.isEqual(smilefill)) {
            //check against previously stored moods
            if (happySelected || neutralSelected || sadSelected || upsetSelected) {
                deleteMood()
                resetbools()
            }
            storeMood(moodType: "smile")
        }
        else if (happydata.isEqual(happyfill)) {
            if (smileSelected || neutralSelected || sadSelected || upsetSelected) {
                deleteMood()
                resetbools()
            }
            storeMood(moodType: "happy")
        }
        else if (neutraldata.isEqual(neutralfill)) {
            if (smileSelected || happySelected || sadSelected || upsetSelected) {
                deleteMood()
                resetbools()
            }
            storeMood(moodType: "neutral")
        }
        else if (saddata.isEqual(sadfill)) {
            if (smileSelected || happySelected || neutralSelected || upsetSelected) {
                deleteMood()
                resetbools()
            }
            storeMood(moodType: "sad")
        }
        else if (upsetdata.isEqual(upsetfill)) {
            if (smileSelected || happySelected || neutralSelected || sadSelected) {
                deleteMood()
                resetbools()
            }
            storeMood(moodType: "upset")
        }
        else {
            deleteMood()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //clearCoreData()
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
        if fetchedResults.count == 0 {
            return
        }
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
    
    func handleSad() {
        if (smileSelected) {
            let smile = UIImage(named: "reallyhappyface")
            smileButton.setImage(smile, for: .normal)
        }
        if (happySelected) {
            let happy = UIImage(named: "happyface")
            happyButton.setImage(happy, for: .normal)
        }
        if (neutralSelected) {
            let neutral = UIImage(named: "neutralface")
            neutralButton.setImage(neutral, for: .normal)
        }
        if (upsetSelected) {
            let upset = UIImage(named: "upsetface")
            upsetButton.setImage(upset, for: .normal)
        }
    }
    
    
    func handleSmile() {
        if (happySelected) {
            let happy = UIImage(named: "happyface")
            happyButton.setImage(happy, for: .normal)
        }
        if (neutralSelected) {
            let neutral = UIImage(named: "neutralface")
            neutralButton.setImage(neutral, for: .normal)
        }
        if (sadSelected) {
            let sad = UIImage(named: "sadface")
            sadButton.setImage(sad, for: .normal)
        }
        if (upsetSelected) {
            let upset = UIImage(named: "upsetface")
            upsetButton.setImage(upset, for: .normal)
        }
    }
    
    func handleHappy() {
        if (smileSelected) {
            let smile = UIImage(named: "reallyhappyface")
            smileButton.setImage(smile, for: .normal)
        }
        if (neutralSelected) {
            let neutral = UIImage(named: "neutralface")
            neutralButton.setImage(neutral, for: .normal)
        }
        if (sadSelected) {
            let sad = UIImage(named: "sadface")
            sadButton.setImage(sad, for: .normal)
        }
        if (upsetSelected) {
            let upset = UIImage(named: "upsetface")
            upsetButton.setImage(upset, for: .normal)
        }
    }
    
    func handleNeutral() {
        if (smileSelected) {
            let smile = UIImage(named: "reallyhappyface")
            smileButton.setImage(smile, for: .normal)
        }
        if (happySelected) {
            let happy = UIImage(named: "happyface")
            happyButton.setImage(happy, for: .normal)
        }
        if (sadSelected) {
            let sad = UIImage(named: "sadface")
            sadButton.setImage(sad, for: .normal)
        }
        if (upsetSelected) {
            let upset = UIImage(named: "upsetface")
            upsetButton.setImage(upset, for: .normal)
        }
    }
    
    func handleUpset() {
        if (smileSelected) {
            let smile = UIImage(named: "reallyhappyface")
            smileButton.setImage(smile, for: .normal)
        }
        if (happySelected) {
            let happy = UIImage(named: "happyface")
            happyButton.setImage(happy, for: .normal)
        }
        if (neutralSelected) {
            let neutral = UIImage(named: "neutralface")
            neutralButton.setImage(neutral, for: .normal)
        }
        if  (sadSelected) {
            let sad = UIImage(named: "sadface")
            sadButton.setImage(sad, for: .normal)
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
