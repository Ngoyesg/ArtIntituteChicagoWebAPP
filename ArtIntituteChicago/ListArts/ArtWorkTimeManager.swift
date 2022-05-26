//
//  ArtWorkTimeManager.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 14/04/22.
//

import Foundation

class ArtworkTimeManager {
    static func secondsElapsed(from lastSeenDate: Date) -> Double {
        let currentDate = Date()
        let result = currentDate.timeIntervalSince(lastSeenDate)
        return result
    }
}
