//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import Foundation

class LineStatusFetcher: NetworkService {

    private var apiUrl: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.tfl.gov.uk"

        guard let userDefaults = UserDefaults.standard.object(forKey: "lineModes") as? [String] else { return nil }

        var enabledLineModes = ""
        for mode in userDefaults {
            if mode != userDefaults.first {
                enabledLineModes.append(",\(mode)")
            } else {
                enabledLineModes.append(mode)
            }
        }

        components.path = "/Line/Mode/\(enabledLineModes)/Status"
        components.queryItems = [URLQueryItem(name: "detail", value: "false")]

        return components.url
    }

    public func update(completion: @escaping ([Line]?) -> Void) {

        guard let apiUrl = apiUrl else { return }

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
