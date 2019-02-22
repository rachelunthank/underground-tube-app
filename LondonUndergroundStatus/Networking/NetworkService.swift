//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import Foundation

protocol NetworkService {
    func update(completion: @escaping ([Line]?, Date?) -> Void)
}
