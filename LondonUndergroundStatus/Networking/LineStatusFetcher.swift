//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case dataError
}

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

    public func update(completion: @escaping ([Line]?, Error?) -> Void) {

        guard let apiUrl = apiUrl else { return }

        URLSession.shared.dataTask(with: apiUrl, completionHandler: { (data, _, error) in

            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let statusData = data else {
                completion(nil, NetworkError.dataError)
                return
            }

            let lines = try? JSONDecoder().decode([Line].self, from: statusData)
            guard lines != nil else {
                completion(nil, NetworkError.decodingError)
                return
            }

            completion(lines, nil)
        }).resume()
    }
}
