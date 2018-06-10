//
//  SettingsViewController.swift
//  TubeApp
//
//  Created by Rachel McGreevy on 02/06/2018.
//  Copyright © 2018 knoxx. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

public class SettingsViewController: UITableViewController {

    @IBOutlet var pushNotificationPermissionsLabel: UILabel!
    @IBOutlet var repeatDaysLabel: UILabel!
    @IBOutlet var repeatTimesLabel: UILabel!

    var daysArray: [String]?
    var timesArray: [Date]?

    override public func viewDidLoad() {
        self.title = "Settings"
        let savedState = readSavedNotificationState()
        self.daysArray = savedState?.notificationDays
        self.timesArray = savedState?.notificationTimes
    }

    func readSavedNotificationState() -> NotificationState? {
        guard let encodedObject = UserDefaults.standard.object(forKey: "notificationState") as? Data else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: encodedObject) as? NotificationState
    }

    override public func viewWillAppear(_ animated: Bool) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in

            DispatchQueue.main.async {
                let pushNotificationsEnabled = settings.authorizationStatus == .authorized
                self.pushNotificationPermissionsLabel.text = pushNotificationsEnabled ? "On" : "Off"
                self.repeatDaysLabel.text = pushNotificationsEnabled ? self.setupDaysLabel() : "None"
                self.repeatDaysLabel.textColor = pushNotificationsEnabled ? .black : .lightGray
                self.repeatTimesLabel.text = pushNotificationsEnabled ? self.setupTimesLabel() : "None"
                self.repeatTimesLabel.textColor = pushNotificationsEnabled ? .black : .lightGray
            }
        }
        setUpNotifications()
    }

    func setUpNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Dont' forget to take a look at the tube status"
        content.sound = UNNotificationSound.default()

        let date = Date(timeIntervalSinceNow: 3600)
        let triggerDate = Calendar.current.dateComponents([.day,.hour,.minute], from: date)

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)

        
    }

    func setupDaysLabel() -> String {

        guard let days = daysArray else { return "Custom" }

        if days.contains("Monday"),
            days.contains("Tuesday"),
            days.contains("Wednesday"),
            days.contains("Thursday"),
            days.contains("Friday"),
            days.count == 5 {
            return "Weekdays"
        }

        if days.contains("Saturday"),
            days.contains("Sunday"),
            days.count == 2 {
            return "Weekends"
        }

        return "Custom"
    }

    func setupTimesLabel() -> String {
        
        guard let times = timesArray else { return "Custom" }

        var timesString = ""

        for i in 0..<times.count {
            let time = times[i]
            let components = Calendar.current.dateComponents([.hour, .minute], from: time)
            guard let hour = components.hour, let minute = components.minute else {
                continue
            }

            timesString += "\(hour):\(minute)"
            if i < times.count - 1 { timesString += ", " }
        }

        if timesString.isEmpty { return "Custom" }

        return timesString
    }
}
