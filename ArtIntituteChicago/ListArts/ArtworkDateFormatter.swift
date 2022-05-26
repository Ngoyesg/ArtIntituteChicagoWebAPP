//
//  ArtworkDateFormatter.swift
//  ArtIntituteChicago
//
//  Created by Natalia Goyes on 14/04/22.
//

import Foundation

class ArtworkDateFormatter {
    static func convertDateToString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
}
