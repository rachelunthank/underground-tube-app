//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import Foundation
import UIKit

public enum TubeLines: String, CaseIterable {
    case bakerloo
    case central
    case circle
    case district
    case hammersmith = "hammersmith-city"
    case jubilee
    case metropolitan
    case northern
    case piccadilly
    case victoria
    case waterloo = "waterloo-city"
    case overground = "london-overground"
    case dlr
    case tram
    case tfl = "tfl-rail"
    case emirates = "emirates-air-line"

    var colorValue: UIColor {
        switch self {
        case .bakerloo:
            return UIColor(red: 178/255, green: 99/255, blue: 0/255, alpha: 1.0)
        case .central:
            return UIColor(red: 220/255, green: 36/255, blue: 31/255, alpha: 1.0)
        case .circle:
            return UIColor(red: 255/255, green: 211/255, blue: 41/255, alpha: 1.0)
        case .district:
            return UIColor(red: 0/255, green: 125/255, blue: 50/255, alpha: 1.0)
        case .hammersmith:
            return UIColor(red: 244/255, green: 169/255, blue: 190/255, alpha: 1.0)
        case .jubilee:
            return UIColor(red: 161/255, green: 165/255, blue: 167/255, alpha: 1.0)
        case .metropolitan:
            return UIColor(red: 155/255, green: 0/255, blue: 88/255, alpha: 1.0)
        case .northern:
            return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        case .piccadilly:
            return UIColor(red: 0/255, green: 25/255, blue: 168/255, alpha: 1.0)
        case .victoria:
            return UIColor(red: 0/255, green: 152/255, blue: 216/255, alpha: 1.0)
        case .waterloo:
            return UIColor(red: 147/255, green: 206/255, blue: 186/255, alpha: 1.0)
        case .overground:
            return UIColor(red: 239/255, green: 123/255, blue: 16/255, alpha: 1.0)
        case .dlr:
            return UIColor(red: 0/255, green: 175/255, blue: 173/255, alpha: 1.0)
        case .tram:
            return UIColor(red: 0/255, green: 189/255, blue: 25/255, alpha: 1.0)
        case .tfl:
            return UIColor(red: 0/255, green: 25/255, blue: 168/255, alpha: 1.0)
        case .emirates:
            return UIColor(red: 220/255, green: 36/255, blue: 31/255, alpha: 1.0)
        }
    }
}
