//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import Foundation

extension Date {

    func timeElapsedSinceDate() -> String {

        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: self, to: Date())

        let timeString: String
        if let days = components.day, days > 0 {
            let dayString = days == 1 ? "day" : "days"
            timeString = "\(days) \(dayString) ago"
        } else if let hours = components.hour, hours > 0 {
            let hourString = hours == 1 ? "hour" : "hours"
            timeString = "\(hours) \(hourString) ago"
        } else if let minutes = components.minute, minutes > 0 {
            let minuteString = minutes == 1 ? "minute" : "minutes"
            timeString = "\(minutes) \(minuteString) ago"
        } else {
            timeString = "just now"
        }

        let localizedUpdateString = String(.lastUpdated)
        return localizedUpdateString.replacingOccurrences(of: "{time}", with: timeString)
    }
}
