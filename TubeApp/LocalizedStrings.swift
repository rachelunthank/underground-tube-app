//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import Foundation

enum LocalizedStrings {
    case liveStatus
    case goodService
    case lastUpdated

    var value: String {
        switch self {
        case .liveStatus: return "live.status"
        case .goodService: return "good.service"
        case .lastUpdated: return "last.updated"
        }
    }
}
