//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import Foundation
import RealmSwift

protocol StorageInteractor {
    func saveToStorage(lines: [Line], lastUpdated: Date)
    func readFromStorage() -> TubeLinesState?
}

class StorageManager: StorageInteractor {

    public func saveToStorage(lines: [Line], lastUpdated: Date) {
        let state = TubeLinesState(with: lines, lastUpdated: lastUpdated)

        guard let realm = try? Realm() else { return }
        try? realm.write {
            guard realm.objects(TubeLinesState.self).first != nil else {
                realm.add(state)
                return
            }
            realm.add(state, update: true)
        }
    }

    func readFromStorage() -> TubeLinesState? {
        guard let realm = try? Realm() else { return nil }
        let lineStates = realm.objects(TubeLinesState.self)
        return lineStates.first
    }
}
