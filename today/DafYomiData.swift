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
}
