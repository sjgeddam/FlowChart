//
//  CalendarViewController.swift
//  FlowChart-iOSProject
//
//  Created by Shannon Radey on 3/30/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"
var dates = [[Int]]()

var monthDict = ["none", "january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"]

var realMonth = 1
var realYear = 2020
var realDay = 1

var curMonth = 1
var curYear = 2020



class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let monthYearLabelColor = UIColor(red: 245/255, green: 157/255, blue: 53/255, alpha: 1)
    
    
    func fillDates() {
        dates.removeAll()
        //let firstDay = firstWeekday()
        let dateString = "01/\(curMonth)/\(curYear)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateFromString = dateFormatter.date(from: dateString)
        let firstDay = Calendar.current.component(.weekday, from: dateFromString!)
        
        // Look up how many days in any month
        let dateComponents = DateComponents(year: curYear, month: curMonth)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        var day = 2 - firstDay
        for _ in 0...5 {
            var week = [Int]()
            for _ in 0...6 {
                if (day <= numDays && day > 0) {
                    week.append(day)
                } else {
                    week.append(0)
                }
                day += 1
            }
            
            dates.append(week)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CalendarCollectionViewCell
        var curDate = false
            
        if (dates[indexPath.section][indexPath.row] == realDay
            && curMonth == realMonth
            && curYear == realYear) {
            curDate = true
        }
        cell.setDate(date: "\(dates[indexPath.section][indexPath.row])", currentDate: curDate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       return CGSize(width: 43, height: 70.0)
    }
    
    @objc func swipeRightDetected(_ sender: UIGestureRecognizer) {
        curMonth -= 1
        if (curMonth == 0) {
            curMonth = 12
            curYear -= 1
        }
        setCalendar()
        collectionView.reloadData()
    }
    
    @objc func swipeLeftDetected(_ sender: UIGestureRecognizer) {
        curMonth += 1
        if (curMonth == 13) {
            curMonth = 1
            curYear += 1
        }
        setCalendar()
        collectionView.reloadData()
    }
    
    func setCalendar() {
        fillDates()
        monthYearLabel.text = "\(monthDict[curMonth]) \(curYear)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Move navigation bar to bottom of screen
        self.navigationController!.navigationBar.frame = CGRect(
            origin: CGPoint(
                x: 0,
                y: UIScreen.main.fixedCoordinateSpace.bounds.height - navigationController!.navigationBar.frame.height),
            size: CGSize(
                width: navigationController!.navigationBar.frame.width,
                height: navigationController!.navigationBar.frame.height))
        
        curMonth = Calendar.current.component(.month, from: NSDate() as Date)
        curYear = Calendar.current.component(.year, from: NSDate() as Date)
        realMonth = curMonth
        realYear = curYear
        realDay = Calendar.current.component(.day, from: NSDate() as Date)
        
        monthYearLabel.textColor = monthYearLabelColor
        
        setCalendar()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightDetected(_:)))
        swipeRightRecognizer.direction = .right
        view.addGestureRecognizer(swipeRightRecognizer)
        
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftDetected(_:)))
        swipeLeftRecognizer.direction = .left
        view.addGestureRecognizer(swipeLeftRecognizer)

    }
    

}
