//
//  DafYomiData.swift
//  daf-yomi
//
//  Created by Yehuda Neufeld on 15/06/2023.
//

import Foundation

struct DafYomiData: Codable {
    let tractate: String
    let daf: String
    let ref: String
    
    func totalDafim() -> Int {
        return Shas.tractates[tractate] ?? 0
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
                numericValue += value
            }
        }
        
        return numericValue
    }
    
    func dafNumber() -> Int {
        // remove non alef-beis
        let dafWithoutGershayim = self.daf.replacingOccurrences(of: "[^א-ת]", with: "", options: .regularExpression)
        // convert to number
        return self.hebrewToNumber(hebrewNumber: dafWithoutGershayim)
    }
    
    func shortTractateName() -> String {
        let words = self.tractate.components(separatedBy: " ")
        if words.count == 2 {
            let firstLetters = words.map { $0.prefix(1).capitalized }
            return firstLetters.joined(separator: "״")
        } else {
            return self.tractate
        }
    }
}
