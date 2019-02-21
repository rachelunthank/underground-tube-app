//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import Foundation

public final class LineStatusFetcher {
    
    private static let apiUrlString = "https://api.tfl.gov.uk/Line/Mode/tube%2Cdlr%2Coverground%2Ctram%2Ctflrail%2Ccable-car/Status?detail=false"
    
    public static func update(completion: @escaping ([Line]?, Date?) -> Void) {
        
        guard let apiUrl = URL(string: apiUrlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: apiUrl, completionHandler: { (data, response, error) in
            do {
                if let statusData = data {
                    let json = try JSONSerialization.jsonObject(with: statusData, options: [])
                    if let jsonObjects = json as? [AnyObject] {
                        let status = self.updateCurrentStatus(with: jsonObjects)
                        completion(status, Date())
                    }
                }
            } catch {
                
            }
        }).resume()
    }
    
    private static func updateCurrentStatus(with json: [AnyObject]) -> [Line] {

        var tubeLineStatus = [Line]()

        for line in json {

            let lineStatus = (line["lineStatuses"] as! [AnyObject])[0]
            let statusDescription = lineStatus["reason"] as? String

            guard let name = line["name"] as? String, let status = lineStatus["statusSeverityDescription"] as? String else {
                continue
            }

            let newLine = Line(name: name, status: status, disruptionDescription: statusDescription)
            tubeLineStatus.append(newLine)
        }

        return tubeLineStatus
    }
    
}
