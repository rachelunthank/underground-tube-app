//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import Foundation

struct LineProperties {
    static let name = "name"
    static let status = "status"
    static let disruptionDescription = "disruptionDescription"
}

public class Line: NSObject, NSCoding {

    var name: String
    var status: String
    var disruptionDescription: String?

    init(name: String, status: String, disruptionDescription: String?) {
        self.name = name
        self.status = status
        self.disruptionDescription = disruptionDescription
    }

    public required init?(coder aDecoder: NSCoder) {

        guard let name = aDecoder.decodeObject(forKey: LineProperties.name) as? String,
            let status = aDecoder.decodeObject(forKey: LineProperties.status) as? String else {

                print("Unable to decode name / status of Line object")
                return nil
        }

        self.name = name
        self.status = status
        self.disruptionDescription = aDecoder.decodeObject(forKey: LineProperties.disruptionDescription) as? String
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: LineProperties.name)
        aCoder.encode(status, forKey: LineProperties.status)
        aCoder.encode(disruptionDescription, forKey: LineProperties.disruptionDescription)
    }
}
