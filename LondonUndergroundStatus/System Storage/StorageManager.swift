//
//  CacheInteractor.swift
//  LondonUndergroundStatus
//
//  Created by Rachel Unthank on 23/02/2019.
//

import Foundation
import RealmSwift

protocol StorageInteractor {
    func saveToStorage(lines: [Line], lastUpdated: Date)
    func readFromStorage() -> TubeLinesState?
}

class StorageManager: StorageInteractor {

    public func saveToStorage(lines: [Line], lastUpdated: Date) {
        let saveState = TubeLinesState(with: lines, lastUpdated: lastUpdated)
        cache(state: saveState)
    }

    private func cache(state: TubeLinesState) {
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
        return uncache()
    }

    private func uncache() -> TubeLinesState? {
        guard let realm = try? Realm() else { return nil }
        let lineStates = realm.objects(TubeLinesState.self)
        return lineStates.first
    }
}
