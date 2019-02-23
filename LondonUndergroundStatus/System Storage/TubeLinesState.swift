//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class TubeLinesState: Object {

    @objc dynamic var lastUpdated: Date = Date()
    let lineStates = List<LineState>()

    init(with lines: [Line], lastUpdated: Date) {
        for line in lines {
            let lineState = LineState(with: line)
            self.lineStates.append(lineState)
        }
        self.lastUpdated = lastUpdated
        super.init()
    }

    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

class LineState: Object {

    @objc dynamic var identifier: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var serviceStatus: String?
    @objc dynamic var disruptionDescription: String?

    convenience init(with line: Line) {
        self.init(identifier: line.identifier,
                  name: line.name,
                  service: line.lineStatuses.first?.statusSeverityDescription,
                  description: line.lineStatuses.first?.reason)
    }

    init(identifier: String, name: String, service: String?, description: String?) {
        self.identifier = identifier
        self.name = name
        self.serviceStatus = service
        self.disruptionDescription = description
        super.init()
    }

    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
