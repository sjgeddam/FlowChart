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
var markedDates:[[(period: Bool, ovulation: Bool, symptoms: Bool)]] = []

var monthDict = ["none", "january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"]

var realMonth = 1
var realYear = 2020
var realDay = 1

var curMonth = 1
var curYear = 2020
var curDay = 1

var curIndexPath: IndexPath!

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    

    
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
        // number of weeks in a month
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // number of days in a week
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
        let markedDay = markedDates[indexPath.section][indexPath.row]
        cell.setDate(date: "\(dates[indexPath.section][indexPath.row])", currentDate: curDate, period: markedDay.period, ovulation: markedDay.ovulation, symptom: markedDay.symptoms, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       return CGSize(width: 43, height: 65)
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
        markedDates.removeAll()
        // Period/ovulation/symptom dates hard coded in
        let periodStart = 27
        let periodLen = 5
        let ovulationStart = 13
        let ovulationLen = 5
        let symptomDates = [4, 5, 10, 18, 20]
        
        //var markedDates:[[(period: Bool, ovulation: Bool, symptoms: Bool)]] = []
        for week in 0...5 {
            var row:[(period: Bool, ovulation: Bool, symptoms: Bool)] = []
            for day in 0...6 {
                var markedDay = (period: false, ovulation: false, symptoms: false)
                if dates[week][day] >= periodStart && dates[week][day] <= periodStart + periodLen {
                    markedDay.period = true
                }
                if dates[week][day] >= ovulationStart && dates[week][day] <= ovulationStart + ovulationLen {
                    markedDay.ovulation = true
                }
                if symptomDates.contains(dates[week][day]) {
                    markedDay.symptoms = true
                }
                row.append(markedDay)
            }
            markedDates.append(row)
        }
        
        
    }
    @IBAction func onClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.navigationController!.setNavigationBarHidden(false,animated:false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout.minimumInteritemSpacing = 12
        self.navigationController!.setNavigationBarHidden(true,animated:false)
        
        curMonth = Calendar.current.component(.month, from: NSDate() as Date)
        curYear = Calendar.current.component(.year, from: NSDate() as Date)
        realMonth = curMonth
        realYear = curYear
        realDay = Calendar.current.component(.day, from: NSDate() as Date)
        
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
    
    @IBAction func onDateClick(_ sender: Any) {
        curDay = Int((sender as! CalendarCellButton).tag)
        curIndexPath = (sender as! CalendarCellButton).indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "dateSegue") {
            let nextVC = segue.destination as? DayOverviewViewController
            nextVC?.delegate = self
            nextVC?.month = curMonth
            nextVC?.day = curDay
            nextVC?.year = curYear
            let indexPath = curIndexPath
            let cell = collectionView.cellForItem(at: indexPath!) as! CalendarCollectionViewCell
            nextVC?.prevColor = cell.markDate.tintColor
            cell.markDate.tintColor = .red
            nextVC?.markedDate = cell.markDate
        }
    }

}
