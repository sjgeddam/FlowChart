//
//  ChecklistViewController.swift
//  FlowChart-iOSProject
//
//  Created by Abby Krishnan on 3/29/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth

class ChecklistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var tableView: UITableView!
    var textCellIdentifier = "Item"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(true,animated:false)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        // Do any additional setup after loading the view.
    }
    
    func retrieveItems()  -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"ChecklistItem")
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
            
            return(fetchedResults)!
        } else {
            print("hello")
          return []
        }
    }
    
    func storeItem(name: String, isChecked: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let note = NSEntityDescription.insertNewObject(
            forEntityName: "ChecklistItem", into: context)
        
        // Set the attribute values
        let user =  Auth.auth().currentUser

        if ((user) != nil) {
            note.setValue(user?.uid, forKey: "userID")
            note.setValue(name, forKey: "name")
            note.setValue(isChecked, forKey: "isChecked")
            
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
    
    func deleteItem(index: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchedResults = retrieveItems()
        let item = fetchedResults[index]
        
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retrieveItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath) as!  CheckableTableViewCell
        
        let fetchedResults = retrieveItems()
        let row = indexPath.row
        let item = fetchedResults[row]
        cell.itemText.text = item.value(forKey:"name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.deleteItem(index: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addItem(_ sender: Any) {
        let ac = UIAlertController(title: "Add to Checklist", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            self.storeItem(name: answer.text!, isChecked: false)
            self.tableView.reloadData()
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
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
