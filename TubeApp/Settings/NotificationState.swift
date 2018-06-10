//
//  NotificationState.swift
//  TubeApp
//
//  Created by Rachel McGreevy on 09/06/2018.
//  Copyright © 2018 knoxx. All rights reserved.
//

import Foundation

struct NotificationStateProperties {
    static let days = "days"
    static let times = "times"
}

public class NotificationState: NSObject, NSCoding {

    var notificationDays: [String]
    var notificationTimes: [Date]

    init(withDays days: [String], times: [Date]) {
        self.notificationDays = days
        self.notificationTimes = times
    }

    public required init?(coder aDecoder: NSCoder) {
        guard let days = aDecoder.decodeObject(forKey: NotificationStateProperties.days) as? [String],
            let times = aDecoder.decodeObject(forKey: NotificationStateProperties.times) as? [Date] else {
                print("Couldn't decode saved days / times")
                return nil
        }
        self.notificationDays = days
        self.notificationTimes = times
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(notificationDays, forKey: NotificationStateProperties.days)
        aCoder.encode(notificationTimes, forKey: NotificationStateProperties.times)
    }

}
