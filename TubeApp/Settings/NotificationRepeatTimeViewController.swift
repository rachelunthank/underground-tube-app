//
//  NotificationRepeatTimeViewController.swift
//  TubeApp
//
//  Created by Rachel McGreevy on 09/06/2018.
//  Copyright © 2018 knoxx. All rights reserved.
//

import Foundation
import UIKit

public class NotificationRepeatTimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addTimeButton: UIButton!

    var dayArray: [String]?
    var timesArray: [Date]?

    public override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.rightBarButtonItem = editButtonItem
        let savedState = readSavedNotificationState()
        self.dayArray = savedState?.notificationDays != nil ? savedState?.notificationDays : ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        self.timesArray = savedState?.notificationTimes != nil ? savedState?.notificationTimes : [Date()]
    }

    override public func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
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

    @IBAction func addTime(_ sender: Any) {
        timesArray?.append(timePicker.date)
        tableView.reloadData()
    }

    func readSavedNotificationState() -> NotificationState? {
        guard let encodedObject = UserDefaults.standard.object(forKey: "notificationState") as? Data else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: encodedObject) as? NotificationState
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timesArray?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()

        guard let times = timesArray else {
            return cell
        }

        let time = times[indexPath.row]
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        guard let hour = components.hour, let minute = components.minute else {
            return cell
        }
        cell.textLabel?.text = "\(hour):\(minute)"
        return cell
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle , forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            timesArray?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
