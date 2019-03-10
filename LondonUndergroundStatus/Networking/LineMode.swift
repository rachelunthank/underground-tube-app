//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import Foundation

enum LineModes: String, CaseIterable {
    case tube
    case dlr
    case overground
    case tram
    case tflrail
    case cableCar = "cable-car"
}

enum LineModeNames: String, CaseIterable {
    case tube = "Tube"
    case dlr = "DLR"
    case overground = "London Overground"
    case tram = "Tram"
    case tflrail = "Tfl Rail"
    case cableCar = "Emirates Air Line"
}
