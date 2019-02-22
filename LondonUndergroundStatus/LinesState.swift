//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import Foundation

struct LineStateProperties {
    static let status = "status"
    static let timestamp = "timestamp"
}

public class LinesState: NSObject, NSCoding {

    var lineStatus: [Line]
    var lastUpdatedTimestamp: Date

    init(withStatus status: [Line], timestamp: Date) {
        self.lineStatus = status
        self.lastUpdatedTimestamp = timestamp
    }

    public required init?(coder aDecoder: NSCoder) {
        guard let status = aDecoder.decodeObject(forKey: LineStateProperties.status) as? [Line],
            let timestamp = aDecoder.decodeObject(forKey: LineStateProperties.timestamp) as? Date else {
                print("Couldn't decode saved status / timestamp")
                return nil
        }
        self.lineStatus = status
        self.lastUpdatedTimestamp = timestamp
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(lineStatus, forKey: LineStateProperties.status)
        aCoder.encode(lastUpdatedTimestamp, forKey: LineStateProperties.timestamp)
    }

}
