//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import Foundation

extension String {

    init(_ localizedString: LocalizedStrings) {
        self = NSLocalizedString(localizedString.value, comment: "")
    }
}
