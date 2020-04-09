//
//  ViewController.swift
//  FlowChart-iOSProject
//
//  Created by Abby Krishnan on 3/10/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit

// global flags, will probably need to be stored in core data and/or firebase
var onPeriod:Bool = false
var startDate:Date = Date()
var endDate:Date? = nil // only set if onPeriod == true


class MainViewController: UIViewController {
    
    // variables related to the menu
    var menuHidden = true
    
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
    
    let dateFormatter = DateFormatter()
    let today = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // filler code to come up with some date
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let someDateTime = dateFormatter.date(from: "2020-04-26")
        let someDateTime2 = dateFormatter.date(from: "2020-04-10")
        startDate = someDateTime!
        endDate = someDateTime2!
        
        // update UI elements to reflect user's phase
        if (!onPeriod && (today <= startDate || Calendar.current.isDateInToday(startDate))) {
            periodWaiting()
        }
        else if (!onPeriod) {
            periodLate()
        }
        else {
            periodStarted()
        }
        
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
        
        // cycle just started
        homeCycleStartedLabel.font = UIFont (name: "ReemKufi-Regular", size: 24)
        homeCalendarButton.imageView?.contentMode = .scaleAspectFit
    }
    
    // period has not yet started
    func periodWaiting () {
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
        
        homeTopLabel.textColor = UIColor(red: 0xf4/255, green: 0x9a/255, blue: 0x5a/255, alpha: 1)
        homeNumberLabel.layer.borderWidth = 3
        homeNumberLabel.textColor = UIColor(red: 0xf4/255, green: 0x9a/255, blue: 0x5a/255, alpha: 1)
        homeNumberLabel.layer.borderColor = UIColor(red: 0xfb/255, green: 0xd4/255, blue: 0xa1/255, alpha: 1).cgColor
        homeNumberLabel.layer.cornerRadius = homeNumberLabel.frame.width/2
        homeBottomLabel.textColor = UIColor(red: 0xf4/255, green: 0x9a/255, blue: 0x5a/255, alpha: 1)
    }
    
    // period has began
    func periodStarted () {
        let startDateDifference = Calendar.current.dateComponents([.day], from: startDate, to: today).day! + 1
        let endDateDifference = Calendar.current.dateComponents([.day], from: today, to: endDate!).day!
        
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
            homeDateLabel.text = "this " + dateFormatter.string(from: endDate!)
        case 6..<13:
            dateFormatter.dateFormat = "EEEE"
            homeDateLabel.text = "next " + dateFormatter.string(from: endDate!)
        default:
            dateFormatter.dateFormat = "MMMM d"
            homeDateLabel.text = dateFormatter.string(from: endDate!)
        }
        
        homeTopLabel.textColor = UIColor(red: 0xf4/255, green: 0x9a/255, blue: 0x5a/255, alpha: 1)
        homeNumberLabel.textColor = UIColor(red: 0xf4/255, green: 0x9a/255, blue: 0x5a/255, alpha: 1)
        homeNumberLabel.layer.cornerRadius = homeNumberLabel.frame.width/2
        homeBottomLabel.textColor = UIColor(red: 0xf4/255, green: 0x9a/255, blue: 0x5a/255, alpha: 1)
        
        // change square size
        homeSquareHeight.constant = 280
        // change bottom label's distance to the top
        homeBottomTop.constant += 50
        // change middle number
        homeNumberCenterY.constant += 20
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
        
        homeTopLabel.textColor = UIColor(red: 0xB4/255, green: 0x18/255, blue: 0x02/255, alpha: 1)
        homeNumberLabel.layer.borderWidth = 3
        homeNumberLabel.textColor = UIColor(red: 0xB4/255, green: 0x18/255, blue: 0x02/255, alpha: 1)
        homeNumberLabel.layer.cornerRadius = 0
        homeNumberLabel.layer.borderColor = UIColor(red: 0xf4/255, green: 0x9a/255, blue: 0x5a/255, alpha: 1).cgColor
        homeBottomLabel.textColor = UIColor(red: 0xB4/255, green: 0x18/255, blue: 0x02/255, alpha: 1)
        homeDateLabel.isHidden = true
    }
    
    // menu animation
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
            
            // animate the "slide in"
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
    }
    
    @IBAction func calendarButtonPressed(_ sender: Any) {
    }
}

