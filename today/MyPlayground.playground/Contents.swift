import UIKit

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
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


func getTodaysDafYomi() -> DafYomiData? {
    guard let url = createSefariaUrl() else {
        print("Error createSefariaUrl")
        return nil
    }
    
    var dafYomiData:DafYomiData? = nil
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        guard let data = data else {
            print("No data received")
            return
        }
        
        if let yourObject = try? JSONDecoder().decode(Welcome.self, from: data) {
            
            guard let dafYomi = yourObject.calendarItems.first(where: { $0.title.en == "Daf Yomi" }) else {
                return
            }
            
            var words = dafYomi.displayValue.he.components(separatedBy: " ")
            let daf = words.popLast()!
            let tractate = words.joined(separator: " ")
            print("daf \(daf), tractate \(tractate)")
            dafYomiData = DafYomiData(tractate: tractate, daf: daf)
            print(dafYomiData!.totalDafim())
        } else {
            print("Invalid JSON format")
        }
    }.resume()
    
    return dafYomiData
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

struct DafYomiData: Codable {
    let tractate: String
    let daf: String
    
    func totalDafim() -> Int {
        let tractateDafim: [String: Int] = [
            "ברכות": 63,
            "שבת": 157,
            "עירובין": 104,
            "פסחים": 121,
            "שקלים": 22,
            "ימא": 87,
            "סוכה": 55,
            "ביצה": 40,
            "ראש השנה": 35,
            "תענית": 31,
            "מגילה": 31,
            "מועד קטן": 28,
            "חגיגה": 27,
            "יבמות": 122,
            "כתובות": 112,
            "נדרים": 91,
            "נזיר": 66,
            "סוטה": 49,
            "גיטין": 90,
            "קידושין": 82,
            "בבא קמא": 118,
            "בבא מציעא": 119,
            "בבא בתרא": 176,
            "סנהדרין": 112,
            "מכות": 24,
            "שבועות": 49,
            "עבודה זרה": 76,
            "הוריות": 13,
            "זבחים": 120,
            "מנחות": 110,
            "חולין": 142,
            "בכורות": 61,
            "ערכין": 34,
            "תמורה": 33,
            "כריתות": 27,
            "מעילה": 26,
            "תמיד": 9,
            "נידה": 73,
        ]
            
        return tractateDafim[tractate] ?? 0
    }
    
    func hebrewToNumber(hebrewNumber: String) -> Int {
        let hebrewToNumeric: [Character: Int] = [
            "א": 1,
           "ב": 2,
           "ג": 3,
           "ד": 4,
           "ה": 5,
           "ו": 6,
           "ז": 7,
           "ח": 8,
           "ט": 9,
           "י": 10,
           "כ": 20,
           "ל": 30,
           "מ": 40,
           "נ": 50,
           "ס": 60,
           "ע": 70,
           "פ": 80,
           "צ": 90,
           "ק": 100,
           "ר": 200,
           "ש": 300,
           "ת": 400
        ]

        var numericValue = 0
        for character in hebrewNumber {
            if let value = hebrewToNumeric[character] {
                numericValue = numericValue * 10 + value
            }
        }
        return numericValue
    }
    
    func dafNumber() -> Int {
        // remove non alef-beis
        let regex = try! NSRegularExpression(pattern: "[^א-ת]")
        let dafWithoutGershayim = regex.stringByReplacingMatches(
            in: self.daf,
            options: [],
            range: NSRange(self.daf.startIndex..., in: self.daf),
            withTemplate: ""
        )
        
        // convert to number
        return self.hebrewToNumber(hebrewNumber: dafWithoutGershayim)
    }
}

getTodaysDafYomi()
