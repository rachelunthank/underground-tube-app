//
//  NotificationRepeatDayViewController.swift
//  TubeApp
//
//  Created by Rachel McGreevy on 09/06/2018.
//  Copyright © 2018 knoxx. All rights reserved.
//

import Foundation
import UIKit

public class NotificationRepeatDayViewController: UITableViewController {

    var dayArray: [String]?
    var timesArray: [Date]?

    override public func viewDidLoad() {
        let savedState = readSavedNotificationState()
        self.dayArray = savedState?.notificationDays != nil ? savedState?.notificationDays : ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        self.timesArray = savedState?.notificationTimes != nil ? savedState?.notificationTimes : [Date()]
    }

    override public func viewWillDisappear(_ animated: Bool) {
        guard let days = dayArray, let times = timesArray else {
            return
        }
        save(notificationState: days, times: times)
    }

    func save(notificationState state: [String], times: [Date]) {
        let notificationState = NotificationState(withDays: state, times: times)
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: notificationState)
        UserDefaults.standard.set(encodedObject, forKey: "notificationState")
        UserDefaults.standard.synchronize()
    }

    func readSavedNotificationState() -> NotificationState? {
        guard let encodedObject = UserDefaults.standard.object(forKey: "notificationState") as? Data else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: encodedObject) as? NotificationState
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return Calendar.current.weekdaySymbols.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        let day = Calendar.current.weekdaySymbols[indexPath.row]
        cell.textLabel?.text = day
        if dayArray?.contains(day) == true {
            cell.accessoryType = .checkmark
        }
        return cell
    }

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let currentlySelected = cell?.accessoryType == .checkmark
        cell?.accessoryType = currentlySelected ? .none : .checkmark
        let day = Calendar.current.weekdaySymbols[indexPath.row]
        if dayArray?.contains(day) == true {
            dayArray = dayArray?.filter{$0 != day}
        } else {
            dayArray?.append(day)
        }
        cell?.setSelected(false, animated: true)
    }
}
