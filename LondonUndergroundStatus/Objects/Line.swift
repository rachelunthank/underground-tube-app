//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import Foundation

struct Line: Codable {
    let type, identifier, name, modeName: String
    let disruptions: [String?]
    let created, modified: String
    let lineStatuses: [LineStatus]
    let routeSections: [String?]
    let serviceTypes: [ServiceType]
    let crowding: Crowding

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case identifier = "id"
        case name, modeName, disruptions, created, modified, lineStatuses, routeSections, serviceTypes, crowding
    }
}

struct Crowding: Codable {
    let type: String

    enum CodingKeys: String, CodingKey {
        case type = "$type"
    }
}

struct LineStatus: Codable {
    let type: String
    let identifier, statusSeverity: Int
    let statusSeverityDescription, created: String
    let validityPeriods: [ValidityPeriod]
    let lineId, reason: String?
    let disruption: Disruption?

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case identifier = "id"
        case statusSeverity, statusSeverityDescription, created, validityPeriods, lineId, reason, disruption
    }
}

struct Disruption: Codable {
    let type, category, categoryDescription, description: String
    let created: String?
    let affectedRoutes, affectedStops: [String?]
    let closureText: String
    let additionalInfo: String?

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case category, categoryDescription, description
        case additionalInfo, created, affectedRoutes, affectedStops, closureText
    }
}

struct ValidityPeriod: Codable {
    let type: String
    let fromDate, toDate: String
    let isNow: Bool

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case fromDate, toDate, isNow
    }
}

struct ServiceType: Codable {
    let type, name, uri: String

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case name, uri
    }
}
