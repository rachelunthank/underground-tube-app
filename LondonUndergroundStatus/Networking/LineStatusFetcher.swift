//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import Foundation

class LineStatusFetcher: NetworkService {

    //swiftlint:disable:next line_length
    private let apiUrlString = "https://api.tfl.gov.uk/Line/Mode/tube%2Cdlr%2Coverground%2Ctram%2Ctflrail%2Ccable-car/Status?detail=false"

    public func update(completion: @escaping ([Line]?) -> Void) {

        guard let apiUrl = URL(string: apiUrlString) else {
            return
        }

        URLSession.shared.dataTask(with: apiUrl, completionHandler: { (data, response, error) in
            if error != nil {
                // handle network error
                print(response.debugDescription)
                completion(nil)
            }
            if let statusData = data {
                guard let lines = try? JSONDecoder().decode([Line].self, from: statusData) else { return }
                completion(lines)
            }
        }).resume()
    }
}
