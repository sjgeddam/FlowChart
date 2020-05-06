//
//  ViewController.swift
//  FlowChart-iOSProject
//
//  Created by Abby Krishnan on 3/10/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import UserNotifications

var predictedDate = false
// global flags, will probably need to be stored in core data and/or firebase
var startDate:Date = Date()
var endDate:Date = Date()
var alreadyMoved:Bool = false
var avgWaitTime = 30
var onPeriod:Bool = false
var averagePeriodLen = 5

protocol NotifDaysChanger {
    func setNotifDates(days: Int)
}
class MainViewController: UIViewController, UNUserNotificationCenterDelegate, NotifDaysChanger {
    
    
    
    // UI variables
    @IBOutlet weak var homeBackgroundView: UIView!
    @IBOutlet weak var homeBackgroundTrailing: NSLayoutConstraint!
    @IBOutlet weak var homeBackgroundLeading: NSLayoutConstraint!
    
    @IBOutlet weak var homeSquareView: UIView!
    @IBOutlet weak var homeSquareHeight: NSLayoutConstraint!
    @IBOutlet weak var homeTopLabel: UILabel!
    @IBOutlet weak var homeNumberLabel: UILabel!
    @IBOutlet weak var homeNumberCenterY: NSLayoutConstraint!
    @IBOutlet weak var homeBottomLabel: UILabel!
    @IBOutlet weak var homeBottomTop: NSLayoutConstraint!
    
    @IBOutlet weak var homeDateLabel: UILabel!
    
    @IBOutlet weak var homeCycleStartedLabel: UILabel!
    @IBOutlet weak var homeCalendarButton: UIButton!
    
    // menu variables
    @IBOutlet weak var menuGoTo: UILabel!
    @IBOutlet weak var menuViewWidth: NSLayoutConstraint!
    @IBOutlet weak var menuCalendarButton: UIButton!
    @IBOutlet weak var menuTrackerButton: UIButton!
    @IBOutlet weak var menuResourcesButton: UIButton!
    @IBOutlet weak var menuCalendarButtonLabel: UIButton!
    @IBOutlet weak var menuTrackerButtonLabel: UIButton!
    @IBOutlet weak var menuResourcesButtonLabel: UIButton!

    var menuHidden = true
    
    // date variables
    let dateFormatter = DateFormatter()
    let today = Date()
    var notifDays = 3
    var lastStart:Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // filler code to come up with some date
//        dateFormatter.dateFormat = "YYYY-MM-dd"
//        let someDateTime = dateFormatter.date(from: "2020-04-26")
//        let someDateTime2 = dateFormatter.date(from: "2020-04-10")
//        startDate = someDateTime!
//        endDate = someDateTime2!
        
        // set startDate and endDate
//        let flowData = retrieveFlow()
//        if flowData.count > 0 {
//            // convert core data's list of NSManagedObject to list of dates
//            let stringDateList = retrieveFlow().compactMap {
//                String(($0.value(forKey: "date") as! String).prefix(1)).capitalized +
//                String(($0.value(forKey: "date") as! String).suffix(($0.value(forKey: "date") as! String).count-1))}
//            dateFormatter.dateFormat = "MMMM d, yyyy"
//            var dateList = stringDateList.compactMap { dateFormatter.date(from: $0 ) }
//            dateList.sort(){$0 > $1}
//
//            if Calendar.current.isDateInToday(dateList[0]) || Calendar.current.isDateInYesterday(dateList[0]) {
//                onPeriod = true
//                startDate = dateList[0]
//                endDate = Calendar.current.date(byAdding: .day, value: 7, to: endDate)!
//
//            }
//            else {
//                onPeriod = false
//                endDate = dateList[0]
//                startDate = Calendar.current.date(byAdding: .day, value: 30, to: endDate)!
//            }
//        }
//        else {
//            // nothing in core data
//            startDate = today
//            endDate = today
//            onPeriod = false
//        }
//
//        // update UI elements to reflect user's phase
//        if (!onPeriod && (today <= startDate || Calendar.current.isDateInToday(startDate))) {
//            periodWaiting()
//        }
//        else if (!onPeriod) {
//            periodLate()
//        }
//        else {
//            periodStarted()
//        }
        
        // UI elements programatic style
        
        // home page container
        homeBackgroundView.layer.zPosition = 900
        homeBackgroundView.center.x = self.view.bounds.width
        
        // square in the center
        homeSquareView.layer.cornerRadius = 40
        homeSquareView.layer.masksToBounds = true
        // square top text
        homeTopLabel.font = UIFont (name: "ReemKufi-Regular", size: 32)
        // square number
        homeNumberLabel.font = UIFont (name: "Raleway-Regular", size: 100)
        // square bottom text
        homeBottomLabel.font = UIFont (name: "ReemKufi-Regular", size: 32)
        
        // date rectangle
        homeDateLabel.layer.cornerRadius = 40
        homeDateLabel.font = UIFont (name: "ReemKufi-Regular", size: 32)
        homeDateLabel.layer.masksToBounds = true
        
        // cycle just started button
        homeCycleStartedLabel.font = UIFont (name: "ReemKufi-Regular", size: 24)
        homeCalendarButton.imageView?.contentMode = .scaleAspectFit
        
        // menu elements
        menuGoTo.font = UIFont (name: "ReemKufi-Regular", size: 32)
        menuViewWidth.constant = view.bounds.width * 0.75
        menuCalendarButton.layer.cornerRadius = 40
        menuCalendarButtonLabel.titleLabel?.font = UIFont (name: "ReemKufi-Regular", size: 24)
        menuTrackerButton.layer.cornerRadius = 40
        menuTrackerButtonLabel.titleLabel?.font = UIFont (name: "ReemKufi-Regular", size: 24)
        menuResourcesButton.layer.cornerRadius = 40
        menuResourcesButtonLabel.titleLabel?.font = UIFont (name: "ReemKufi-Regular", size: 24)
        UNUserNotificationCenter.current().delegate = self
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let day = Calendar.current.component(.day, from: NSDate() as Date)
        let month = Calendar.current.component(.month, from: NSDate() as Date)
        let year = Calendar.current.component(.year, from: NSDate() as Date)
        
        let dateStr = "\(monthDict[month]) \(day), \(year)"
        let flow = PeriodData.retrieveItems(item: "Flow")
        onPeriod = false


        let df = DateFormatter()
        df.dateFormat = "MM dd, yyyy"
        var convertedArray: [Date] = []

        for f in flow {
            let dat = f.value(forKey:"date") as? String ?? ""
            if dat == dateStr {
                onPeriod = true
            }
            let date = df.date(from: dat)
            if let date = date {
                convertedArray.append(date)
            }
        }

        let ready = convertedArray.sorted(by: { $0.compare($1) == .orderedDescending })
        var lastEnd = Date()
        lastStart = Date()
        var index = 0
        var max = -1
        while index + 1 < ready.count {
            let dateDifference = Calendar.current.dateComponents([.day], from: ready[index + 1], to: ready[index]).day!
            
            if dateDifference > max {
                max = dateDifference
            }
            
            if dateDifference > 1 {
                lastStart = ready[index]
                lastEnd = ready[0]
                break
            }
            index += 1
            
            
        }
        
        if max == 1 && ready.count > 0 {
            lastStart = ready[ready.count-1]
            lastEnd = ready[0]
        }
        if ready.count == 1 {
            lastStart = ready[0]
            lastEnd = ready[0]
        }
        
//        if endDate != nil && endDate >= today {
//            onPeriod = true
//        }

        var cycle:[NSManagedObject] = PeriodData.retrieveItems(item: "Cycle")
        cycle = cycle.sorted(by: { ($0.value(forKey: "start") as! Date).compare($1.value(forKey: "start") as! Date) == .orderedAscending })
        var lastEndDate = Date()
        if !onPeriod {
            // calculate average between cycles
            var count = 1
            var sum = 0
            if (cycle.count > 1) {
                for (index, entry) in (cycle.enumerated()) {
                    let start = entry.value(forKey: "start") as! Date
                    let end = entry.value(forKey: "end") as! Date
//                    print("start is \(start), end is \(end)")
                    if index != 0 {
                        count += 1
                        let dateDifference = Calendar.current.dateComponents([.day], from: lastEndDate, to: start).day!
                        sum += dateDifference
                    }
                    lastEndDate = end
                }
            }
//            print("SUMMMMMM = {}", sum)
            if sum > 0 {
                avgWaitTime = Int(round(Double(sum)/Double(count)))
//                print("avg cycle wait time is \(avgWaitTime) = (\(sum)/\(count))")
            }
            else { // reset to 30 if no entries
                avgWaitTime = 30
            }
            startDate = Calendar.current.date(byAdding: .day, value: avgWaitTime, to: lastEnd) ?? Date()
            endDate = lastEnd
            predictedDate = true

        }
        else {
            // calculate average cycle length
            var count = 0
            var sum = 0
            if (cycle.count > 1) {
                for entry in cycle {
                    count += 1
                    let start = entry.value(forKey: "start") as! Date
                    let end = entry.value(forKey: "end") as! Date
//                    print("start is \(start), end is \(end)")
                    let dateDifference = Calendar.current.dateComponents([.day], from: start, to: end).day!
                    sum += dateDifference
                }
            }
            if sum > 0 {
                averagePeriodLen = Int(round(Double(sum)/Double(count)))
//                print("avg cycle length is \(averagePeriodLen) = (\(sum)/\(count))")
            }
            else { // reset to 5 if no entries
                averagePeriodLen = 5
            }
            startDate = lastStart
            endDate = Calendar.current.date(byAdding: .day, value: averagePeriodLen, to: lastStart) ?? Date()
        }
        
        
        // update UI elements to reflect user's phase
        if (ready.count == 0) {
            startDate = Date()
            endDate = Date()
            periodWaiting()
        }
        if (!onPeriod && (today <= startDate || Calendar.current.isDateInToday(startDate))) {
//            print("waiting for period. end date was \(endDate)")
            periodWaiting()
            scheduleNotification(type: "WAITING")
        }
        else if (!onPeriod) {
            periodLate()
            scheduleNotification(type: "LATE")
        }
        else {
//            print("on period. end date is \(endDate)")
            periodStarted()
            scheduleNotification(type: "ONPERIOD")
        }
    }
    func setNotifDates(days: Int) {
        notifDays = days
    }
    func scheduleNotification(type: String) {
        let center = UNUserNotificationCenter.current()
        var currentNotif:UNNotificationRequest? = nil
        // finding the current pending notification
        center.getPendingNotificationRequests { (notifications) in
            for notif in notifications {
                currentNotif = notif
//                print(notif.content.body)
            }
        }
        // schedules 3 types of notifications -
        // one that prompts you a certain number of days before
        // one that reminds you to log your period ending
        // one that reminds you that you were late/asks for confirmation
        let notification = UNMutableNotificationContent()
        // preventing a double add
        if type == "WAITING" && !(currentNotif != nil && currentNotif?.identifier == "WAITING") {
            // get rid of old pending notifs if status changed
            center.removePendingNotificationRequests(withIdentifiers: ["LATE", "ONPERIOD"])
            notification.title = "Period Prediction"
            notification.subtitle = "Did your period start?"
            notification.body = "Your period is predicted to start in " + String(notifDays) + " day(s)."
            // scheduling the notification to show up this notif days before
            var dayComponent = DateComponents()
            dayComponent.day = notifDays * -1
            
            var nextDate = Calendar.current.date(byAdding: dayComponent, to: startDate) ?? Date()
            var component = Calendar.current.dateComponents([.year, .month, .day], from: nextDate)
            component.hour = 10
            // if its too little days before setting, show the notif in 2 hours
            if nextDate < Date() {
                nextDate = Date()
                let hoursFromNow = (Calendar.current.component(.hour, from: Date()) + 2) % 24
                component.hour = hoursFromNow
                let daysUntilStart = Calendar.current.dateComponents([.day], from: today, to: startDate).day!
                notification.body = "Your period is predicted to start in " + String(daysUntilStart) + " days."
            }
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
            let request = UNNotificationRequest(identifier: type,
            content: notification,
            trigger: trigger)
            
            center.add(request) { (error) in}
        }
        // preventing a double add
        else if type == "ONPERIOD" && !(currentNotif != nil && currentNotif?.identifier == "ONPERIOD") {
            // get rid of old pending notifs if status changed
            center.removePendingNotificationRequests(withIdentifiers: ["LATE", "WAITING"])
            
            notification.title = "Period Prediction"
            notification.subtitle = "Did your period end?"
            notification.body = "Your period was predicted to end today. Log the end in FlowChart"
            
            var component = Calendar.current.dateComponents([.year, .month, .day], from: endDate)
            component.hour = 10
            let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
            let request = UNNotificationRequest(identifier: type,
            content: notification,
            trigger: trigger)
            
            center.add(request) { (error) in}

        }
        // preventing a double add
        else if type == "LATE" && !(currentNotif != nil && currentNotif?.identifier == "LATE") {
            // get rid of old pending notifs if status changed
            center.removePendingNotificationRequests(withIdentifiers: ["ONPERIOD", "WAITING"])
            
            notification.title = "Period Prediction"
            notification.subtitle = "Did your period start?"
            var dayComponent = DateComponents()
            dayComponent.day = notifDays
            let nextDate = Calendar.current.date(byAdding: dayComponent, to: Date()) ?? Date()
            let dayDifference = Calendar.current.dateComponents([.day], from: startDate, to: today).day!
            notification.body = "Last time you logged in your period was " + String(dayDifference) + " days late."
            var component = Calendar.current.dateComponents([.year, .month, .day], from: nextDate)
            component.hour = 10
            let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
            let request = UNNotificationRequest(identifier: type,
            content: notification,
            trigger: trigger)
            
            center.add(request) { (error) in}
        }
        
        
    }
    // period has not yet started
    func periodWaiting () {
        // check if the past cycle needs to be logged
        let cycle:[NSManagedObject] = PeriodData.retrieveItems(item: "Cycle")
        var endDates:[Date] = []
        for date in cycle {
            endDates.append(date.value(forKey: "end") as! Date)
        }
        if (!endDates.contains(endDate) && PeriodData.retrieveItems(item: "Flow").count != 0) {
            storeCycle(start: lastStart, end: endDate)
        }
        
        let dateDifference = Calendar.current.dateComponents([.day], from: today, to: startDate).day!
        
        homeTopLabel.text = "projected start in"
        homeNumberLabel.text = String(dateDifference)
        
        if dateDifference != 1 {
            homeBottomLabel.text = "days"
        }
        else {
            homeBottomLabel.text = "day"
        }
        
        switch dateDifference {
        case 0: homeDateLabel.text = "today"
        case 1: homeDateLabel.text = "tomorrow"
        case 2..<6:
            dateFormatter.dateFormat = "EEEE"
            homeDateLabel.text = "this " + dateFormatter.string(from: startDate)
        case 6..<13:
            dateFormatter.dateFormat = "EEEE"
            homeDateLabel.text = "next " + dateFormatter.string(from: startDate)
        default:
            dateFormatter.dateFormat = "MMMM d"
            homeDateLabel.text = dateFormatter.string(from: startDate)
        }
        
        // UI element changes
        homeTopLabel.textColor = UIColor(red: 0xf4/255, green: 0x9a/255, blue: 0x5a/255, alpha: 1)
        homeNumberLabel.layer.borderWidth = 3
        homeNumberLabel.textColor = UIColor(red: 0xf4/255, green: 0x9a/255, blue: 0x5a/255, alpha: 1)
        homeNumberLabel.layer.borderColor = UIColor(red: 0xfb/255, green: 0xd4/255, blue: 0xa1/255, alpha: 1).cgColor
        homeNumberLabel.layer.cornerRadius = homeNumberLabel.frame.width/2
        homeBottomLabel.textColor = UIColor(red: 0xf4/255, green: 0x9a/255, blue: 0x5a/255, alpha: 1)
        
        // undo periodStarted changes
        homeCycleStartedLabel.text = "cycle just started"
        homeCalendarButton.setImage(UIImage(systemName: "plus.circle.fill")!, for: [])
        homeNumberLabel.attributedText = NSAttributedString(string: homeNumberLabel.text!, attributes:
        [NSAttributedString.Key.underlineStyle: 0])
        // change square size
        homeSquareHeight.constant = 344
        // change bottom label's distance to the top
        homeBottomTop.constant = 350
//        if alreadyMoved {
//            homeBottomTop.constant -= 50
//            // change middle number
////            homeNumberCenterY.constant += 20
//            alreadyMoved = false
//        }
    }
    
    // period has began
    func periodStarted () {
        let startDateDifference = Calendar.current.dateComponents([.day], from: startDate, to: today).day! + 1
        let endDateDifference = Calendar.current.dateComponents([.day], from: today, to: endDate).day!
        
        homeTopLabel.text = "cycle day"
        homeNumberLabel.text = String(startDateDifference)
        homeBottomLabel.text = "ends"
        homeCycleStartedLabel.text = "cycle just ended"
        homeCalendarButton.setImage(UIImage(systemName: "minus.circle.fill")!, for: [])
        
        switch endDateDifference {
        case 0: homeDateLabel.text = "today"
        case 1: homeDateLabel.text = "tomorrow"
        case 2..<6:
            dateFormatter.dateFormat = "EEEE"
            homeDateLabel.text = "this " + dateFormatter.string(from: endDate)
        case 6..<13:
            dateFormatter.dateFormat = "EEEE"
            homeDateLabel.text = "next " + dateFormatter.string(from: endDate)
        default:
            dateFormatter.dateFormat = "MMMM d"
            homeDateLabel.text = dateFormatter.string(from: endDate)
        }
        
        // UI element changes
        homeTopLabel.textColor = UIColor(red: 0xf4/255, green: 0x9a/255, blue: 0x5a/255, alpha: 1)
        homeNumberLabel.textColor = UIColor(red: 0xf4/255, green: 0x9a/255, blue: 0x5a/255, alpha: 1)
        homeNumberLabel.layer.cornerRadius = homeNumberLabel.frame.width/2
        homeBottomLabel.textColor = UIColor(red: 0xf4/255, green: 0x9a/255, blue: 0x5a/255, alpha: 1)
        
        // change square size
        homeSquareHeight.constant = 280
        // change bottom label's distance to the top
        homeBottomTop.constant = 400
//        if !alreadyMoved {
//            homeBottomTop.constant += 50
//            // change middle number
////            homeNumberCenterY.constant += 20
//            alreadyMoved = true
//        }
        homeNumberLabel.layer.borderWidth = 0.0
        homeNumberLabel.attributedText = NSAttributedString(string: homeNumberLabel.text!, attributes:
            [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    // period is late
    func periodLate () {
        let dayDifference = Calendar.current.dateComponents([.day], from: startDate, to: today).day!
        
        homeTopLabel.text = "late!"
        homeNumberLabel.text = String(dayDifference)
        
        if dayDifference > 1 {
            homeBottomLabel.text = "days"
        }
        else {
            homeBottomLabel.text = "day"
        }
        
        // UI elements changes
        homeTopLabel.textColor = UIColor(red: 0xB4/255, green: 0x18/255, blue: 0x02/255, alpha: 1)
        homeNumberLabel.layer.borderWidth = 3
        homeNumberLabel.textColor = UIColor(red: 0xB4/255, green: 0x18/255, blue: 0x02/255, alpha: 1)
        homeNumberLabel.layer.cornerRadius = 0
        homeNumberLabel.layer.borderColor = UIColor(red: 0xf4/255, green: 0x9a/255, blue: 0x5a/255, alpha: 1).cgColor
        homeBottomLabel.textColor = UIColor(red: 0xB4/255, green: 0x18/255, blue: 0x02/255, alpha: 1)
        homeDateLabel.isHidden = true
    }
    
    // automatically moves menu back if openend
    func moveMenuBack() {
        // move background view constraints back to center
        self.homeBackgroundLeading.constant = 0
        self.homeBackgroundTrailing.constant = 0
        
        // animate the "slide out"
        UIView.animate(
        withDuration: 0.4,
        delay: 0.0,
        options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            // remove blur view
            self.view.viewWithTag(420)?.removeFromSuperview()
        },
        completion: nil)
        
        menuHidden = true
    }
    
    // menu animation when button is pressed
    @IBAction func menuButtonPressed(_ sender: Any) {
        
        if menuHidden == true {
            
            // add a blur view effect
            let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.tag = 420
            blurEffectView.layer.zPosition = 999
            view.addSubview(blurEffectView)
            blurEffectView.alpha = 0
            
            // move background view to the right to give illusion that menu is sliding out from left
            self.homeBackgroundLeading.constant = self.view.bounds.width * 0.75
            self.homeBackgroundTrailing.constant = self.view.bounds.width * 0.75
            
            // animate the menu "slide in"
            UIView.animate(
                withDuration: 0.4,
                delay: 0.0,
                options: .curveEaseInOut, animations: {
                    UIView.animate(
                    withDuration: 0.2,
                    delay: 0.0,
                    options: .curveLinear, animations: {
                        blurEffectView.alpha = 1
                    })
                    // update constraints
                    self.view.layoutIfNeeded()
                    // move blur view to cover background view
                    blurEffectView.center.x = self.view.bounds.width * 1.25
                },
                completion: nil)
            
            menuHidden = false
        }
        else {
            
            moveMenuBack()
        }
    }
    
    // menu buttons
    @IBAction func menuCalendarPressed(_ sender: Any) {
        moveMenuBack()
    }
    @IBAction func menuTrackerPressed(_ sender: Any) {
        moveMenuBack()
    }
    @IBAction func menuResourcesPressed(_ sender: Any) {
        moveMenuBack()
    }
    @IBAction func menuCalendarLabelPressed(_ sender: Any) {
        performSegue(withIdentifier: "segueToCalendar", sender: nil)
        moveMenuBack()
    }
    @IBAction func menuTrackerLabelPressed(_ sender: Any) {
        performSegue(withIdentifier: "segueToTracker", sender: nil)
        moveMenuBack()
    }
    @IBAction func menuResourcesLabelPressed(_ sender: Any) {
        performSegue(withIdentifier: "segueToResources", sender: nil)
        moveMenuBack()
    }
    
    // going to tracker
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToTracker" {
            let nextVC = segue.destination as? TrackerViewController
            nextVC?.delegate = self
        }
        if segue.identifier == "segueToSettings" {
            let nextVC = segue.destination as? SettingsViewController
            nextVC?.delegate = self
        }
        if segue.identifier == "segueToCalendar" {
            let nextVC = segue.destination as? CalendarViewController
            nextVC?.delegate = self
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
    
    
    //clear core data for flow
    func clearCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Flow")
        var fetchedResults:[NSManagedObject]
        
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            if fetchedResults.count > 0 {
                for result:AnyObject in fetchedResults {
//                    context.delete(result as! NSManagedObject)
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
}

