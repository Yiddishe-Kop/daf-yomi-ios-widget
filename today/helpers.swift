//
//  DafYomiData.swift
//  daf-yomi
//
//  Created by Yehuda Neufeld on 15/06/2023.
//

import Foundation
import Combine

// MARK: - Welcome
struct CalendarsResponse: Codable {
    let date, timezone: String
    let calendarItems: [CalendarItem]

    enum CodingKeys: String, CodingKey {
        case date, timezone
        case calendarItems = "calendar_items"
    }
}

// MARK: - CalendarItem
struct CalendarItem: Codable {
    let title, displayValue: Description
    let url: String
    let ref, heRef: String?
    let order: Int
    let category: String
    let extraDetails: ExtraDetails?
    let description: Description?
}

// MARK: - Description
struct Description: Codable {
    let en, he: String
}

// MARK: - ExtraDetails
struct ExtraDetails: Codable {
    let aliyot: [String]
}

func splitDate(_ date: Date) -> (day: Int, month: Int, year: Int) {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day, .month, .year], from: date)
    
    guard let day = components.day,
          let month = components.month,
          let year = components.year else {
        fatalError("Failed to split the date")
    }
    
    return (day, month, year)
}
