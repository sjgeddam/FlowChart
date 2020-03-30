//
//  ChecklistViewController.swift
//  FlowChart-iOSProject
//
//  Created by Abby Krishnan on 3/29/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit

class ChecklistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var checklist:[String] = []
    @IBOutlet weak var tableView: UITableView!
    var textCellIdentifier = "Item"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checklist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath) as!  CheckableTableViewCell
        
        let row = indexPath.row
        cell.itemText.text = checklist[row]
        return cell
    }
    @IBAction func addItem(_ sender: Any) {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            self.checklist.append(answer.text!)
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
