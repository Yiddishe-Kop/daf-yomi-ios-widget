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


class APIManager: ObservableObject {
    @Published var dafYomiData: DafYomiData? = nil
    @Published var heText: [[String]] = [[]]
    
    func fetchText(completion: (() -> Void)? = nil) {
        if (dafYomiData == nil) {
            return
        }
        
        print("https://www.sefaria.org/api/texts/\(self.dafYomiData!.ref)")
        
        guard let url = URL(string: "https://www.sefaria.org/api/texts/\(self.dafYomiData!.ref)") else {
            print("Error createSefariaUrl 1")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("Data not found")
                return
            }
            
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let heText = jsonObject["he"] as? [[String]] {
                        DispatchQueue.main.async {
                            self.heText = heText
                            completion?()
                        }
                    }
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }.resume()
    }
        
    func fetchDafYomi(completion: (() -> Void)? = nil) {
        
        guard let url = createSefariaUrl() else {
            print("Error createSefariaUrl")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("Data not found")
                return
            }
            
            let decodedData = try? JSONDecoder().decode(CalendarsResponse.self, from: data)
            guard let dafYomi = decodedData!.calendarItems.first(where: { $0.title.en == "Daf Yomi" }) else {
                return
            }
            
            var words = dafYomi.displayValue.he.components(separatedBy: " ")
            let daf = words.popLast()!.replacingOccurrences(of: "[^א-ת]", with: "", options: .regularExpression)
            let tractate = words.joined(separator: " ")
            
            DispatchQueue.main.async {
                self.dafYomiData = DafYomiData(tractate: tractate, daf: daf, ref: dafYomi.url)
                completion?()
            }
        }.resume()
    }
}


func createSefariaUrl() -> URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "www.sefaria.org"
    urlComponents.path = "/api/calendars"

    let currentDate = Date()
    let dateComponents = splitDate(currentDate)

    // Create query items
    let queryItems = [
        URLQueryItem(name: "lang", value: "he"),
        URLQueryItem(name: "timezone", value: "Asia/Jerusalem"),
        URLQueryItem(name: "custom", value: "ashkenazi"),
        URLQueryItem(name: "day", value: String(dateComponents.day)),
        URLQueryItem(name: "month", value: String(dateComponents.month)),
        URLQueryItem(name: "year", value: String(dateComponents.year))
    ]

    urlComponents.queryItems = queryItems

    return urlComponents.url
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
