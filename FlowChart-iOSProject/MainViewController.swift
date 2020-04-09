//
//  ViewController.swift
//  FlowChart-iOSProject
//
//  Created by Abby Krishnan on 3/10/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit

// global flags, will probably need to be stored in core data and/or firebase
var onPeriod:Bool = true
var startDate:Date = Date()
var endDate:Date? = nil // only set if onPeriod == true


class MainViewController: UIViewController {
    
    @IBOutlet weak var homeBackgroundView: UIView!
    @IBOutlet weak var homeSlideMenu: UIView!
    
    
    
    var menuHidden = true
    
    @IBOutlet weak var homeTopLabel: UILabel!
    @IBOutlet weak var homeNumberLabel: UILabel!
    @IBOutlet weak var homeBottomLabel: UILabel!
    @IBOutlet weak var homeDateLabel: UILabel!
    
    @IBOutlet weak var homeSquareView: UIView!
    
    let dateFormatter = DateFormatter()
    let today = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeBackgroundView.layer.zPosition = 900;
        
        // filler code to come up with some date
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let someDateTime = dateFormatter.date(from: "2020-03-30")
        let someDateTime2 = dateFormatter.date(from: "2020-04-02")
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
        homeDateLabel.layer.cornerRadius = 40
        homeNumberLabel.layer.cornerRadius = homeNumberLabel.frame.width/2
        homeNumberLabel.layer.borderColor = UIColor(red: 0xf4/255, green: 0x9a/255, blue: 0x5a/255, alpha: 1).cgColor
        homeNumberLabel.layer.borderWidth = 3
        
        homeTopLabel.font = UIFont (name: "ReemKufi-Regular", size: 32)
        homeNumberLabel.font = UIFont (name: "Raleway-Regular", size: 100)
        homeBottomLabel.font = UIFont (name: "ReemKufi-Regular", size: 32)
        homeDateLabel.font = UIFont (name: "ReemKufi-Regular", size: 32)
        homeSquareView.layer.cornerRadius = 40
        homeDateLabel.layer.masksToBounds = true
        homeSquareView.layer.masksToBounds = true
//         homeSquareView.layer.frame = CGRect(x: homeSquareView.layer.frame.minX, y: homeSquareView.layer.frame.minY, width: homeSquareView.layer.frame.width, height: homeSquareView.layer.frame.height - 90)
        
        
        


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
    }
    
    // period has began
    func periodStarted () {
        let startDateDifference = Calendar.current.dateComponents([.day], from: startDate, to: today).day! + 1
        let endDateDifference = Calendar.current.dateComponents([.day], from: today, to: endDate!).day!
        
        homeTopLabel.text = "cycle day"
        homeNumberLabel.text = String(startDateDifference)
        homeBottomLabel.text = "ends"
        
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
        
        // change UI
        NSLayoutConstraint.activate([homeSquareView.heightAnchor.constraint(equalToConstant: 290)])
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
        
        homeDateLabel.text = ""
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        if menuHidden == true {
            // blur background
            let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.tag = 420
            blurEffectView.layer.zPosition = 999
            view.addSubview(blurEffectView)
            
            UIView.animate(
                withDuration: 0.2,
                delay: 0.0,
                options: .curveEaseInOut, animations: {
                    self.homeBackgroundView.center.x = self.view.bounds.width * 1.25
                    blurEffectView.center.x = self.view.bounds.width * 1.25
                },
                completion: nil)
            
            menuHidden = false
        }
        else {
            UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: .curveEaseInOut, animations: {
                self.view.viewWithTag(420)?.removeFromSuperview()
                self.homeBackgroundView.center.x = self.view.center.x
            },
            completion: nil)
            
            menuHidden = true
        }
    }
    
    @IBAction func calendarButtonPressed(_ sender: Any) {
    }
}

