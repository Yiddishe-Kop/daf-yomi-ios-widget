//
//  SefariaClient.swift
//  הדף היומי
//
//  Created by Yehuda Neufeld on 30/03/2024.
//

import Foundation

class SefariaClient {

    static func fetchText(ref: String) async throws -> [[String]] {
        let urlString = "https://www.sefaria.org/api/texts/\(ref)"
        
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "com.yiddishe-kop", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let heText = jsonObject["he"] as? [[String]] else {
            throw NSError(domain: "com.yiddishe-kop", code: 500, userInfo: [NSLocalizedDescriptionKey: "Error parsing response"])
        }
        
        return heText
    }
    
    static func fetchTodaysDafYomi() async throws -> DafYomiData {
        
        guard let url = self.buildCalenderUrlParams() else {
            throw NSError(domain: "com.yiddishe-kop", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decodedData = try? JSONDecoder().decode(CalendarsResponse.self, from: data)
        guard let dafYomi = decodedData!.calendarItems.first(where: { $0.title.en == "Daf Yomi" }) else {
            throw NSError(domain: "com.yiddishe-kop", code: 500, userInfo: [NSLocalizedDescriptionKey: "Error parsing response"])
        }
        
        var words = dafYomi.displayValue.he.components(separatedBy: " ")
        let daf = words.popLast()!.replacingOccurrences(of: "[^א-ת]", with: "", options: .regularExpression)
        let tractate = words.joined(separator: " ")
        
        return DafYomiData(tractate: tractate, daf: daf, ref: dafYomi.url)
    }
    
    static func buildCalenderUrlParams() -> URL? {
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
}
